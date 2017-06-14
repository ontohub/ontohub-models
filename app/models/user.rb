# frozen_string_literal: true

# The class representing an actual user
class User < OrganizationalUnit
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
    :lockable

  many_to_many :organizations,
    join_table: :organization_memberships, left_key: :member_id
  one_to_many :organization_memberships
  one_to_many :repository_memberships, key: :member_id

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

  def validate
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

  # Workaround: This is the exact same implementation as in devise, with the
  # exception that the GMT offset is added to the time. There seems to be a bug
  # in PostgreSQL, Sequel or Sequel-Rails that stores the UTC time in the
  # database correctly, but when reading from the database, it subtracts the
  # GMT offset once more and tells that it's UTC.
  # :nocov:
  # This is implicitly tested in the backend.
  def lock_access!(opts = {})
    self.locked_at = Time.now.utc + Time.now.gmtoff

    if unlock_strategy_enabled?(:email) && opts.fetch(:send_instructions, true)
      send_unlock_instructions
    else
      save(validate: false)
    end
  end
  # :nocov:
end
