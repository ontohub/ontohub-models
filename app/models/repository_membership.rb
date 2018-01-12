# frozen_string_literal: true

# The class representing an Repository Membership
class RepositoryMembership < Sequel::Model
  ROLES = %w(admin write read).freeze

  plugin :validation_helpers

  many_to_one :member, class: User
  many_to_one :repository

  def validate
    validates_includes ROLES, :role
  end
end
