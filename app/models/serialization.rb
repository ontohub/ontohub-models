# frozen_string_literal: true

# The Serialization model
class Serialization < Sequel::Model
  many_to_one :language

  def to_param
    slug
  end
end
