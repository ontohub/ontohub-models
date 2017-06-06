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

  devise :database_authenticatable, :registerable

  many_to_many :organizations,
    join_table: :organization_memberships, left_key: :member_id
  one_to_many :organization_memberships
  one_to_many :repository_memberships, key: :member_id

  # one_to_many :accessible_repositories, dataset: (proc do |reflection|
  #   reflection.associated_dataset.
  #     graph(:organizations, {id: :owner_id}, select: false).
  #     graph(:organization_memberships, {organization_id: :id}, select: false).
  #     graph(:users, {id: :member_id}, select: false).
  #     where(Sequel[:repositories][:owner_id] => id).
  #     or(Sequel[:repositories][:owner_id] =>
  #       Sequel[:organizations_members][:organization_id],
  #       Sequel[:organizations_members][:member_id] => id)
  # end), class: Repository

  def validate
    validates_format(Devise.email_regexp, :email)
    validates_presence(:password) if new?
    unless password.nil?
      min = Devise.password_length.first
      max = Devise.password_length.last
      validates_length_range(Devise.password_length, :password,
        message: "must be between #{min} and #{max} characters")
    end
    super
  end

  def repositories_by_organizations
    organizations.reduce([]) do |org_repos, organization|
      org_repos + organization.repositories
    end
  end

  def repositories_by_membership
    repository_memberships.map(&:repository).uniq
  end

  def foreign_repositories
    (repositories_by_organizations + repositories_by_membership).uniq
  end

  def accessible_repositories
    (foreign_repositories + repositories).uniq
  end
end
