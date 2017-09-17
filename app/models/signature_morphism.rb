# frozen_string_literal: true

# The SignatureMorphism transforms one signature into another along a logic
# mapping
class SignatureMorphism < Sequel::Model
  many_to_one :logic_mapping
  many_to_one :source, class: Signature
  many_to_one :target, class: Signature
  one_to_many :mappings
  one_to_many :symbol_mappings
end
