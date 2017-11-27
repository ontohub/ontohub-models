# frozen_string_literal: true

# The SignatureMorphism transforms one signature into another along a logic
# mapping
class SignatureMorphism < Sequel::Model
  many_to_one :logic_mapping
  many_to_one :source, class: Signature
  many_to_one :target, class: Signature
  one_to_many :mappings
  one_to_many :symbol_mappings

  # Equivalent to [source, target].map(&:repositories).flatten
  one_to_many :repositories, dataset: (proc do |reflection|
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
      graph(:signatures,
            {Sequel[:oms][:signature_id] => Sequel[:signatures][:id]},
            join_type: :inner, select: false).
      graph(:signature_morphisms,
            {Sequel[:as_source][:source_id] => Sequel[:signatures][:id]},
            table_alias: :as_source, join_type: :left, select: false).
      graph(:signature_morphisms,
            {Sequel[:as_target][:target_id] => Sequel[:signatures][:id]},
            table_alias: :as_target, join_type: :left, select: false).
      where(Sequel[:as_source][:id] => id).
      or(Sequel[:as_target][:id] => id)
  end), class: Repository
end
