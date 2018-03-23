# frozen_string_literal: true

# The OMS model
class OMS < LocIdBase
  CONSISTENCY_STATUSES =
    (%w(Contradictory) +
     ConsistencyCheckAttempt::CONSISTENCY_STATUSES).freeze

  ORIGINS = %w(dg_empty dg_basic dg_basic_spec dg_extension dg_logic_coercion
               dg_translation dg_union dg_intersect dg_extract dg_restriction
               dg_reveal_translation free cofree np_free minimize dg_local
               dg_closed dg_logic_qual dg_data dg_formal_params
               dg_verification_generic dg_imports dg_inst dg_fit_spec
               dg_fit_view dg_proof dg_normal_form dg_integrated_scc
               dg_flattening dg_alignment dg_test).freeze

  plugin :validation_helpers

  many_to_one :action
  many_to_one :document
  many_to_one :language
  many_to_one :logic
  many_to_one :serialization
  many_to_one :signature
  many_to_one :normal_form, class: OMS
  many_to_one :normal_form_signature_morphism, class: SignatureMorphism
  many_to_one :free_normal_form, class: OMS
  many_to_one :free_normal_form_signature_morphism, class: SignatureMorphism
  many_to_one :conservativity_status
  many_to_one :name_file_range, class: FileRange
  one_to_many :consistency_check_attempts

  one_to_many :sentences
  one_to_many :axioms
  one_to_many :conjectures
  one_to_many :open_conjectures
  one_to_many :theorems
  one_to_many :counter_theorems

  one_to_many :mappings_by_source, dataset: (proc do |reflection|
    reflection.associated_dataset.where(source_id: id)
  end), class: Mapping

  one_to_many :mappings_by_target, dataset: (proc do |reflection|
    reflection.associated_dataset.where(target_id: id)
  end), class: Mapping

  one_to_many :mappings, dataset: (proc do |reflection|
    reflection.associated_dataset.where(source_id: id).or(target_id: id)
  end), class: Mapping

  # Equivalent to file_version.repository
  one_to_one :repository, dataset: (proc do |reflection|
    reflection.associated_dataset.
      graph(:file_versions,
            {Sequel[:file_versions][:repository_id] =>
               Sequel[:repositories][:id]},
            join_type: :inner, select: false).
      graph(:loc_id_bases,
            {Sequel[:documents][:file_version_id] =>
               Sequel[:file_versions][:id]},
            table_alias: :documents, join_type: :inner, select: false).
      graph(:oms,
            {Sequel[:oms][:document_id] => Sequel[:documents][:id]},
            join_type: :inner, select: false).
      where(Sequel[:oms][:id] => id)
  end), class: Repository

  def validate
    validates_includes ORIGINS, :origin
    validates_includes CONSISTENCY_STATUSES, :consistency_status
    super
  end
end
