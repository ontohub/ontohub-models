# frozen_string_literal: true

# The class representing an actual user
class User < OrganizationalUnit
  plugin :devise

  devise :database_authenticatable

  many_to_many :organizations,
    join_table: :organizations_members, left_key: :member_id

  one_to_many :accessible_repositories, dataset: (proc do |reflection|
    reflection.associated_dataset.
      where(owner_id: id).
      or(owner_id: organizations_dataset.select(:organizational_units__id))
  end), class: Repository
end
