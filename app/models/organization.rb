# frozen_string_literal: true

# The class representing an actual Organization
class Organization < OrganizationalUnit
  many_to_many :members, class: User, join_table: :organizations_members
end
