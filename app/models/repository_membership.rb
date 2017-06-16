# frozen_string_literal: true

# The class representing an Repository Membership
class RepositoryMembership < Sequel::Model
  many_to_one :repository
  many_to_one :member, class: User

  def validate
    validates_includes %w(admin write read), :role
  end
end
