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
  many_to_one :cons_status
  many_to_one :name_file_range, class: FileRange

  one_to_many :mappings_source, dataset: (proc do |reflection|
    reflection.associated_dataset.where(source_id: id)
  end), class: Mapping

  one_to_many :mappings_target, dataset: (proc do |reflection|
    reflection.associated_dataset.where(target_id: id)
  end), class: Mapping

  one_to_many :mappings, dataset: (proc do |reflection|
    reflection.associated_dataset.where(source_id: id).or(target_id: id)
  end), class: Mapping
end
