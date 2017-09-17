# frozen_string_literal: true

# The OMSSymbol model is a Symbol in terms of DOL.
# This class is called OMSSymbol because Symbol is already taken by Ruby.
class OMSSymbol < LocIdBase
  many_to_one :oms
  many_to_one :file_range
  many_to_many :sentences, join_table: :sentences_symbols, left_key: :symbol_id
  many_to_many :signatures, join_table: :signature_symbols, left_key: :symbol_id
end
