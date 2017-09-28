# frozen_string_literal: true

# The SineSymbolCommonness saves the commonness of a symbol inside an OMS
class SineSymbolCommonness < Sequel::Model
  many_to_one :sine_premise_selection
  many_to_one :symbol, class: OMSSymbol
end
