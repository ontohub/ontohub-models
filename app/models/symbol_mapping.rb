# frozen_string_literal: true

# The SymbolMapping translates one OMSSymbol into another along a
# SignatureMorphism
class SymbolMapping < Sequel::Model
  many_to_one :signature_morphism
  many_to_one :source, class: OMSSymbol
  many_to_one :target, class: OMSSymbol
end
