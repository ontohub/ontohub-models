# frozen_string_literal: true

# The ReasoningAttempt model
class ReasoningAttempt < Sequel::Model
  plugin :single_table_inheritance, :kind

  many_to_one :conjecture, class: Conjecture
  many_to_one :reasoner_configuration
  many_to_one :used_reasoner, class: Reasoner
  one_to_many :reasoning_attempts
  one_to_many :generated_axioms
  one_to_one :reasoner_output
end
