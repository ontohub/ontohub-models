# frozen_string_literal: true

# The Repository model groups libraries and exposes the basic git functinoality.
class Repository < Sequel::Model
  plugin :timestamps
  plugin :validation_helpers

  include Slug
  slug_base :name
  slug_condition :new?

  def validate
    validates_length_range (3..100), :name
    super
  end
end
