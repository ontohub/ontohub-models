# frozen_string_literal: true

# The Sentence model
class Sentence < LocIdBase
  many_to_one :oms, class: OMS
  many_to_one :file_range
  many_to_many :symbols, class: OMSSymbol, join_table: :sentences_symbols

  # If this sentence is created by a mapping, this refers to the original
  # sentence:
  one_to_one :original_sentence, class: Sentence, dataset: (proc do |reflection|
    # If we do not return this custom dataset, Sequel adds a where clause
    # with a wrong column
    reflection.associated_dataset.
      where(Sequel[:loc_id_bases][:id] => original_sentence_id)
  end)

  # Equivalent to oms.repository
  one_to_one :repository, dataset: (proc do |reflection|
    reflection.associated_dataset.
      graph(:file_versions,
            {Sequel[:file_versions][:repository_id] =>
               Sequel[:repositories][:id]},
            join_type: :inner, select: false).
      graph(:loc_id_bases,
            {Sequel[:sentences][:file_version_id] =>
               Sequel[:file_versions][:id]},
            table_alias: :sentences, join_type: :inner, select: false).
      where(Sequel[:sentences][:id] => id)
  end), class: Repository
end
