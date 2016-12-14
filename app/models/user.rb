# frozen_string_literal: true

# The class representing an actual user
class User < OrganizationalUnit
  plugin :devise

  devise :database_authenticatable

  many_to_many :organizations,
    join_table: :organizations_members, left_key: :member_id

  one_to_many :accessible_repositories, dataset: (proc do |reflection|
    reflection.associated_dataset.
      graph(:organizations, {id: :owner_id}, select: false).
      graph(:organizations_members, {organization_id: :id}, select: false).
      graph(:users, {id: :member_id}, select: false).
      where(repositories__owner_id: id).
      or(repositories__owner_id: :organizations_members__organization_id,
         organizations_members__member_id: id)
  end), class: Repository
end
