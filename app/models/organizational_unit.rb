# frozen_string_literal: true

# Superclass of Organization and User
class OrganizationalUnit < Sequel::Model
  plugin :validation_helpers
  plugin :class_table_inheritance, key: :kind, alias: :organizational_units

  # Use a non-persisted attribute to create the slug
  attr_accessor :name

  include Slug
  slug_base :name
  slug_condition :new?

  one_to_many :repositories, key: :owner_id
  plugin :association_dependencies, repositories: :destroy

  def validate
    if new?
      validates_length_range (3..100), :name
      validates_format(Slug::DEFAULT_SLUG_FORMAT, :name,
                       message: 'must start and end with a lower case letter '\
                                'or number, and only contain lower case '\
                                'letters, numbers, "-" and "_"')
    end
    validates_length_range (0..100), :display_name unless display_name.nil?
    super
  end
end
