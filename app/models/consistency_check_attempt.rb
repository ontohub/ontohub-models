# frozen_string_literal: true

# The ConsistencyCheckAttempt model
class ConsistencyCheckAttempt < ReasoningAttempt
  CONSISTENCY_STATUSES = %w(Open Timeout Error Consistent Inconsistent).freeze

  many_to_one :oms, class: OMS

  # Equivalent to oms.repository
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
      where(Sequel[:loc_id_bases][:id] => oms_id)
  end), class: Repository

  def validate
    validates_includes CONSISTENCY_STATUSES, :consistency_status
    super
  end
end
