# frozen_string_literal: true

# The SinePremiseSelection is an automatic parameterised premise selection
class SinePremiseSelection < PremiseSelection
  one_to_many :sine_symbol_premise_triggers
  one_to_many :sine_symbol_commonnesses
end
