# frozen_string_literal: true

# Superclass of Team and User
class OrganizationalUnit < Sequel::Model
  plugin :timestamps
  plugin :validation_helpers
  plugin :class_table_inheritance

  include Slug
  slug_base :name
  slug_condition :new?

  def validate
    validates_length_range (3..100), :name
    super
  end
end
