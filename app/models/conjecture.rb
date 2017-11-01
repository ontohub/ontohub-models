# frozen_string_literal: true

# The Conjecture model
class Conjecture < Sentence
  one_to_many :proof_attempts
end
