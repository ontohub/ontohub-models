# frozen_string_literal: true

# The ReasoningAttempt model
class ReasoningAttempt < Sequel::Model
  EVALUATION_STATES = %w(not_yet_enqueued enqueued processing
                         finished_successfully finished_unsuccessfully).freeze
  REASONING_STATUSES ||= %w(OPN ERR UNK RSO THM CSA CSAS).freeze

  plugin :validation_helpers

  plugin :class_table_inheritance, key: :kind, alias: :reasoning_attempts

  many_to_one :reasoner_configuration
  many_to_one :used_logic_mapping, class: LogicMapping
  many_to_one :used_reasoner, class: Reasoner
  one_to_many :generated_axioms
  one_to_one :reasoner_output

  def validate
    validates_includes EVALUATION_STATES, :evaluation_state
    validates_includes REASONING_STATUSES, :reasoning_status
    super
  end
end
