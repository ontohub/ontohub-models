# frozen_string_literal: true

# The configuration of a Reasoner
class ReasonerConfiguration < Sequel::Model
  many_to_one :configured_reasoner, class: Reasoner
  one_to_many :reasoning_attempts
  one_to_many :premise_selections
end
