# frozen_string_literal: true

# Represents an action that is performed in the background
class Action < Sequel::Model
  EVALUATION_STATES = %w(not_yet_enqueued enqueued processing
                         finished_successfully finished_unsuccessfully).freeze
  plugin :validation_helpers

  def validate
    validates_includes EVALUATION_STATES, :evaluation_state
    super
  end
end
