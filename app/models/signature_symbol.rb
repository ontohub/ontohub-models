# frozen_string_literal: true

# The SignatureSymbol association model links a symbol to a signature and tells
# whether or not it is an imported symbol
class SignatureSymbol < Sequel::Model
  # The primary key is compound (id values of the associations). Allow to set
  # these in mass assignment.
  unrestrict_primary_key

  many_to_one :signature
  many_to_one :symbol, class: OMSSymbol
end
