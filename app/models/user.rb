# frozen_string_literal: true

# The class representing an actual user
# rubocop:disable Metrics/ClassLength
# This class cannot be shortened by moving the associations into an
# ActiveSupport::Concern because then, Sequel cannot define the association
# methods.
class User < OrganizationalUnit
  # rubocop:enable Metrics/ClassLength
  # Devise workaround: This allows the user to be authenticated by a :name
  # parameter, that is actually the slug. The public API expects to receive
  # the slug as :name while devise expects the slug as :slug.
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    conditions[:slug] = conditions.delete(:name) if conditions[:name]
    super(conditions)
  end

  plugin :devise
  devise :database_authenticatable, :registerable, :confirmable, :recoverable,
    :lockable, :trackable

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, id, *args).deliver_later
  end

  one_to_many :public_keys

  many_to_many :organizations,
    join_table: :organization_memberships, left_key: :member_id
  one_to_many :organization_memberships, key: :member_id
  one_to_many :repository_memberships, key: :member_id

  plugin :association_dependencies,
    organizations: :nullify,
    repository_memberships: :delete,
    public_keys: :delete

  # equivalent to
  # organization_memberships.where(role: role).map(&:organization)
  def organizations_by_role(role)
    @organizations_by_role_dataset ||= Organization.dataset.
      join(:organization_memberships, {organization_id: :id}, select: false).
      where(Sequel[:organization_memberships][:role] => role,
            Sequel[:organization_memberships][:member_id] => id)
  end

  # equivalent to
  # organizations.reduce([]) do |org_repos, organization|
  #   org_repos + organization.repositories
  # end
  one_to_many :repositories_by_organizations, dataset: (proc do |reflection|
    reflection.associated_dataset.
      graph(:organizations, {id: :owner_id}, select: false).
      graph(:organization_memberships, {organization_id: :id}, select: false).
      graph(:users, {id: :member_id}, select: false).
      where(Sequel[:repositories][:owner_id] =>
            Sequel[:organization_memberships][:organization_id],
            Sequel[:organization_memberships][:member_id] => id)
  end), class: Repository

  # equivalent to
  # repository_memberships.map(&:repository).uniq
  one_to_many :repositories_by_membership, dataset: (proc do |reflection|
    reflection.associated_dataset.
      graph(:repository_memberships,
            {repository_id: Sequel[:repositories][:id]},
            select: false).
      graph(:users, {id: :member_id}, select: false).
      where(Sequel[:repository_memberships][:member_id] => id)
  end), class: Repository

  # equivalent to
  # (repositories_by_organizations + repositories_by_membership).uniq
  one_to_many :foreign_repositories, dataset: (proc do |reflection|
    reflection.associated_dataset.
      graph(:organizations, {id: :owner_id}, select: false).
      graph(:organization_memberships, {organization_id: :id}, select: false).
      graph(:users, {id: :member_id}, select: false).

      graph(:repository_memberships,
            {repository_id: Sequel[:repositories][:id]},
            select: false).
      graph(:users, {id: :member_id},
            table_alias: :users_repository,
            select: false).
      where(Sequel[:repositories][:owner_id] =>
            Sequel[:organization_memberships][:organization_id],
            Sequel[:organization_memberships][:member_id] => id).
      or(Sequel[:repository_memberships][:member_id] => id)
  end), class: Repository

  # equivalent to
  # (foreign_repositories + repositories).uniq
  one_to_many :accessible_repositories, dataset: (proc do |reflection|
    reflection.associated_dataset.
      graph(:organizations, {id: :owner_id}, select: false).
      graph(:organization_memberships, {organization_id: :id}, select: false).
      graph(:users, {id: :member_id}, select: false).

      graph(:repository_memberships,
            {repository_id: Sequel[:repositories][:id]},
            select: false).
      graph(:users, {id: :member_id},
            table_alias: :users_repository,
            select: false).
      where(Sequel[:repositories][:owner_id] =>
            Sequel[:organization_memberships][:organization_id],
            Sequel[:organization_memberships][:member_id] => id).
      or(Sequel[:repository_memberships][:member_id] => id).
      or(Sequel[:repositories][:owner_id] => id)
  end), class: Repository

  # rubocop:disable Metrics/MethodLength
  def validate
    # rubocop:enable Metrics/MethodLength
    validates_includes %w(admin user), :role
    validates_format(Devise.email_regexp, :email)
    validates_unique(:email)
    validates_presence(:password) if new?
    unless password.nil?
      min = Devise.password_length.first
      max = Devise.password_length.last
      validates_length_range(Devise.password_length, :password,
        message: "must be between #{min} and #{max} characters")
    end
    super
  end

  # Devise uses email_was to determine the old email address when sending an
  # email changed message. This could also be implemented via the +dirty+
  # plugin, but this method is not used very often, so the plugin would be
  # overhead.
  def email_was
    self.class.find(id: id).email
  end

  # Devise Trackable requires these two attributes to be defined, but we do not
  # want to store the IP addresses in the database. These empty getters and
  # setters work around Devise's requirement:
  %i(current_sign_in_ip last_sign_in_ip).each do |method|
    define_method(method) {}
    define_method("#{method}=") { |_ip| }
  end

  def email_hash
    @email_hash ||= Digest::MD5.hexdigest(email)
  end

  def admin?
    role.eql?('admin')
  end
end
