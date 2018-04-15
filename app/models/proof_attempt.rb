# frozen_string_literal: true

# The ProofAttempt model
class ProofAttempt < ReasoningAttempt
  PROOF_STATUSES ||= %w(OPN ERR UNK RSO THM CSA CSAS).freeze

  many_to_one :conjecture, class: Conjecture

  many_to_many :used_sentences, join_table: :proof_attempts_used_sentences,
                                left_key: :proof_attempt_id,
                                right_key: :sentence_id,
                                class: Sentence

  # Equivalent to conjecture.repository
  one_to_one :repository, dataset: (proc do |reflection|
    reflection.associated_dataset.
      graph(:file_versions,
            {Sequel[:file_versions][:repository_id] =>
               Sequel[:repositories][:id]},
            join_type: :inner, select: false).
      graph(:loc_id_bases,
            {Sequel[:loc_id_bases][:file_version_id] =>
               Sequel[:file_versions][:id]},
            join_type: :inner, select: false).
      where(Sequel[:loc_id_bases][:id] => conjecture_id)
  end), class: Repository

  def validate
    validates_includes PROOF_STATUSES, :proof_status
    super
  end
end
