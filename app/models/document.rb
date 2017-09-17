# frozen_string_literal: true

# The Document model contains OMS
class Document < LocIdBase
  one_to_many :document_links_source, dataset: (proc do |reflection|
    reflection.associated_dataset.
      where(Sequel[:document_links][:source_id] => id)
  end), class: DocumentLink

  one_to_many :document_links_target, dataset: (proc do |reflection|
    reflection.associated_dataset.
      where(Sequel[:document_links][:target_id] => id)
  end), class: DocumentLink

  one_to_many :document_links, dataset: (proc do |reflection|
    reflection.associated_dataset.
      where(Sequel[:document_links][:target_id] => id).
      or(Sequel[:document_links][:source_id] => id)
  end), class: DocumentLink
end
