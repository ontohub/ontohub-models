# frozen_string_literal: true

# The ProofAttempt model
class ProofAttempt < ReasoningAttempt
  many_to_one :conjecture, class: Conjecture

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
end
