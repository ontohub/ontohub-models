# frozen_string_literal: true

# The class representing an actual Organization
class Organization < OrganizationalUnit
  many_to_many :members, class: User, join_table: :organization_memberships
  one_to_many :organization_memberships

  plugin :association_dependencies, members: :nullify
end
