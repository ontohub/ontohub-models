# frozen_string_literal: true

# The SineSymbolAxiomTrigger model tells which symbol triggers which axiom at
# which minimum tolerance
class SineSymbolPremiseTrigger < Sequel::Model
  many_to_one :sine_premise_selection
  many_to_one :premise, class: Sentence
  many_to_one :symbol, class: OMSSymbol
end
