# frozen_string_literal: true

# The OMS model
class OMS < LocIdBase
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
end
