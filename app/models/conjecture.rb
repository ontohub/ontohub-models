# frozen_string_literal: true

# The Conjecture model
class Conjecture < Sentence
  REASONING_STATUSES ||= %w(OPN ERR UNK RSO THM CSA CSAS CONTR).freeze

  plugin :validation_helpers

  many_to_one :action
  one_to_many :proof_attempts

  def validate
    validates_presence :action
    validates_includes REASONING_STATUSES, :reasoning_status
    super
  end
end
