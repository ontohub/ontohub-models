# frozen_string_literal: true

# The Conjecture model
class Conjecture < Sentence
  EVALUATION_STATES = %w(not_yet_enqueued enqueued processing
                         finished_successfully finished_unsuccessfully).freeze
  REASONING_STATUSES ||= %w(OPN ERR UNK RSO THM CSA CSAS CONTR).freeze

  plugin :validation_helpers

  one_to_many :proof_attempts

  def validate
    validates_includes EVALUATION_STATES, :evaluation_state
    validates_includes REASONING_STATUSES, :reasoning_status
    super
  end
end
