# frozen_string_literal: true

# The Document model contains OMS
class Document < LocIdBase
  one_to_many :document_links_by_source, dataset: (proc do |reflection|
    reflection.associated_dataset.
      where(Sequel[:document_links][:source_id] => id)
  end), class: DocumentLink

  one_to_many :document_links_by_target, dataset: (proc do |reflection|
    reflection.associated_dataset.
      where(Sequel[:document_links][:target_id] => id)
  end), class: DocumentLink

  one_to_many :document_links, dataset: (proc do |reflection|
    reflection.associated_dataset.
      where(Sequel[:document_links][:target_id] => id).
      or(Sequel[:document_links][:source_id] => id)
  end), class: DocumentLink

  # Documents that import this one
  many_to_many :imported_by,
    left_key: :target_id,
    right_key: :source_id,
    join_table: :document_links,
    class: Document

  # Documents that this one imports
  many_to_many :imports,
    left_key: :source_id,
    right_key: :target_id,
    join_table: :document_links,
    class: Document
end
