# frozen_string_literal: true

# Superclass of Organization and User
class OrganizationalUnit < Sequel::Model
  plugin :timestamps
  plugin :validation_helpers
  plugin :class_table_inheritance, key: :kind

  include ModelWithURL

  include Slug
  slug_base :name
  slug_condition :new?

  one_to_many :repositories, key: :owner_id
  plugin :association_dependencies, repositories: :destroy

  def validate
    validates_length_range (3..100), :name
    super
  end
end
