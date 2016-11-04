# frozen_string_literal: true

# The Repository model groups libraries and exposes the basic git functinoality.
class Repository < Sequel::Model
  plugin :timestamps
  plugin :validation_helpers

  include Slug
  slug_base :name
  slug_condition :new?

  many_to_one :namespace

  def validate
    validates_length_range (3..100), :name
    validates_presence :namespace_id
    validates_presence :private_access
    validates_includes %w(ontology model specification), :content
    super
  end
end
