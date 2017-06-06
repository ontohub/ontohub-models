# frozen_string_literal: true

# The class representing an Organization Membership
class OrganizationMembership < Sequel::Model
  many_to_one :member, class: User
  many_to_one :organization
end
