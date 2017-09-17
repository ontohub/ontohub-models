# frozen_string_literal: true

# The GeneratedAxiom represents an axiom that only exists in a proof
class GeneratedAxiom < Sequel::Model
  many_to_one :reasoning_attempt
end
