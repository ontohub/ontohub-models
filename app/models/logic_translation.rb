# frozen_string_literal: true

# The LogicTranslation model describes a translation from one Logic into another
# and may do this with many steps.
class LogicTranslation < Sequel::Model
  one_to_many :logic_translation_steps

  def to_param
    slug
  end
end
