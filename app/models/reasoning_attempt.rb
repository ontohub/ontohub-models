# frozen_string_literal: true

# The ReasoningAttempt model
class ReasoningAttempt < Sequel::Model
  REASONING_STATUSES ||= %w(OPN ERR UNK RSO THM CSA CSAS).freeze

  plugin :validation_helpers

  plugin :class_table_inheritance, key: :kind, alias: :reasoning_attempts

  many_to_one :action
  many_to_one :reasoner_configuration
  many_to_one :used_logic_mapping, class: LogicMapping
  many_to_one :used_reasoner, class: Reasoner
  one_to_many :generated_axioms
  one_to_one :reasoner_output

  def validate
    validates_presence :action
    validates_includes REASONING_STATUSES, :reasoning_status
    super
  end
end
