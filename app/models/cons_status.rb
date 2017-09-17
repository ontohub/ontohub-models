# frozen_string_literal: true

# The Consistency Status
class ConsStatus < Sequel::Model
  one_to_one :mappings
end
