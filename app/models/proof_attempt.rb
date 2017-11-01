# frozen_string_literal: true

# The ProofAttempt model
class ProofAttempt < ReasoningAttempt
  many_to_one :conjecture, class: Conjecture
end
