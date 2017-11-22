# frozen_string_literal: true

# The Signature is a collection of OMSSymbols as JSON
class Signature < Sequel::Model
  many_to_one :language
  one_to_many :oms, class: OMS
  many_to_many :symbols, class: OMSSymbol, join_table: :signature_symbols

  many_to_many :non_imported_symbols, dataset: (proc do |reflection|
    reflection.associated_dataset.
      where(Sequel[:signature_symbols][:signature_id] => id,
            Sequel[:signature_symbols][:imported] => false)
  end), class: OMSSymbol, join_table: :signature_symbols, right_key: :symbol_id

  many_to_many :imported_symbols, dataset: (proc do |reflection|
    reflection.associated_dataset.
      where(Sequel[:signature_symbols][:signature_id] => id,
            Sequel[:signature_symbols][:imported] => true)
  end), class: OMSSymbol, join_table: :signature_symbols, right_key: :symbol_id

  one_to_many :signature_morphisms_by_source, dataset: (proc do |reflection|
    reflection.associated_dataset.
      where(Sequel[:signature_morphisms][:source_id] => id)
  end), class: SignatureMorphism

  one_to_many :signature_morphisms_by_target, dataset: (proc do |reflection|
    reflection.associated_dataset.
      where(Sequel[:signature_morphisms][:target_id] => id)
  end), class: SignatureMorphism

  one_to_many :signature_morphisms, dataset: (proc do |reflection|
    reflection.associated_dataset.
      where(Sequel[:signature_morphisms][:target_id] => id).
      or(Sequel[:signature_morphisms][:source_id] => id)
  end), class: SignatureMorphism

  # Equivalent to oms.map { |oms| oms.repository }
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
      where(Sequel[:signatures][:id] => id)
  end), class: Repository

  def add_symbol(symbol, imported)
    SignatureSymbol.new(signature_id: id,
                        symbol_id: symbol.id,
                        imported: imported).save
  end

  def remove_symbol(symbol)
    SignatureSymbol.first(signature_id: id,
                          symbol_id: symbol.id).destroy
  end
end
