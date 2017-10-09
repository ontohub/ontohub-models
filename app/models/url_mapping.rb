# frozen_string_literal: true

# The UrlMapping
class UrlMapping < Sequel::Model
  plugin :validation_helpers

  many_to_one :repository

  def validate
    validates_presence :source
    validates_presence :target
    super
  end
end
