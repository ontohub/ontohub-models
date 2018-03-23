# frozen_string_literal: true

# The LogicTranslationStep model describes one step in a translation from one
# Logic into another.
class LogicTranslationStep < Sequel::Model
  many_to_one :logic_translation
  many_to_one :logic_mapping
  many_to_one :logic_inclusion
end
