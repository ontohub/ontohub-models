# frozen_string_literal: true

# The ReasoningAttempt model
class ReasoningAttempt < Sequel::Model
  plugin :class_table_inheritance, key: :kind, alias: :reasoning_attempts

  many_to_one :reasoner_configuration
  many_to_one :used_reasoner, class: Reasoner
  one_to_many :reasoning_attempts
  one_to_many :generated_axioms
  one_to_one :reasoner_output
end
