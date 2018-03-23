# frozen_string_literal: true

# The LogicInclusion model describes a translation from one Logic into another
# inside the same language.
class LogicInclusion < Sequel::Model
  many_to_one :language
  many_to_one :source, class: Logic
  many_to_one :target, class: Logic

  def to_param
    slug
  end
end
