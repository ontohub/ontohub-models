# frozen_string_literal: true

# Superclass of Team and User
class OrganizationalUnit < Sequel::Model
  plugin :timestamps
  plugin :validation_helpers
  plugin :class_table_inheritance

  include Slug
  slug_base :name
  slug_condition :new?

  one_to_one :namespace

  def validate
    validates_length_range (3..100), :name
    super
  end

  protected

  # NOTE: Always create an OrganizationalUnit in a transaction in order to keep
  # the database consistent. This after_create method must be part of the
  # transaction.
  def after_create
    self.namespace = Namespace.new
  end
end
