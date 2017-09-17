# frozen_string_literal: true

# The ReasonerOutput represents the text-output of a reasoner
class ReasonerOutput < Sequel::Model
  many_to_one :reasoning_attempt
  many_to_one :reasoner
end
