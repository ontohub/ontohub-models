# frozen_string_literal: true

# The LogicMapping model describes a translation from one Logic into another.
class LogicMapping < Sequel::Model
  many_to_one :language_mapping
  many_to_one :source, class: Language
  many_to_one :target, class: Language
end
