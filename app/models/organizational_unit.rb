# frozen_string_literal: true

# Superclass of Organization and User
class OrganizationalUnit < Sequel::Model
  plugin :timestamps
  plugin :validation_helpers
  plugin :class_table_inheritance, key: :kind

  include ModelWithURL

  include Slug
  attr_accessor :name
  slug_base :name
  slug_condition :new?

  one_to_many :repositories, key: :owner_id
  plugin :association_dependencies, repositories: :destroy

  def validate
    validates_length_range (3..100), :name if new?
    validates_length_range (0..100), :real_name if real_name.present?
    super
  end
end
