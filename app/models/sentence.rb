# frozen_string_literal: true

# The Sentence model
class Sentence < LocIdBase
  many_to_one :oms, class: OMS
  many_to_one :file_range
  many_to_many :symbols, class: OMSSymbol, join_table: :sentences_symbols
end
