# frozen_string_literal: true

# The Language model
class Language < Sequel::Model
  one_to_many :logics
  one_to_many :oms, class: OMS

  one_to_many :language_mappings_source, dataset: (proc do |reflection|
    reflection.associated_dataset.
      where(Sequel[:language_mappings][:source_id] => id)
  end), class: LanguageMapping

  one_to_many :language_mappings_target, dataset: (proc do |reflection|
    reflection.associated_dataset.
      where(Sequel[:language_mappings][:target_id] => id)
  end), class: LanguageMapping

  one_to_many :language_mappings, dataset: (proc do |reflection|
    reflection.associated_dataset.
      where(Sequel[:language_mappings][:target_id] => id).
      or(Sequel[:language_mappings][:source_id] => id)
  end), class: LanguageMapping
end
