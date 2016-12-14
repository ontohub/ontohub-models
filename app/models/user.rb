# frozen_string_literal: true

# The class representing an actual user
class User < OrganizationalUnit
  plugin :devise

  devise :database_authenticatable

  many_to_many :organizations,
    join_table: :organizations_members, left_key: :member_id

  def accessible_repositories
    repositories + organizations.map(&:repositories).flatten
  end
end
