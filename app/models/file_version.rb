# frozen_string_literal: true

# Represents a specific version of a file. There exists only a FileVersion for
# a git commit that actually changes the file.
class FileVersion < Sequel::Model
  EVALUATION_STATES = %w(not_yet_enqueued enqueued processing
                         finished_successfully finished_unsuccessfully).freeze
  plugin :validation_helpers

  many_to_one :repository
  one_to_many :diagnoses

  def validate
    validates_presence :repository
    validates_presence :commit_sha
    validates_format(/\A[a-f0-9]{40}\z/, :commit_sha)
    validates_presence :path
    validates_includes EVALUATION_STATES, :evaluation_state if evaluation_state
    super
  end
end
