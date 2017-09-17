# frozen_string_literal: true

# The Logic model
class Logic < Sequel::Model
  many_to_one :language
  one_to_many :oms, class: OMS

  one_to_many :logic_mappings_source, dataset: (proc do |reflection|
    reflection.associated_dataset.
      where(Sequel[:logic_mappings][:source_id] => id)
  end), class: LogicMapping

  one_to_many :logic_mappings_target, dataset: (proc do |reflection|
    reflection.associated_dataset.
      where(Sequel[:logic_mappings][:target_id] => id)
  end), class: LogicMapping

  one_to_many :logic_mappings, dataset: (proc do |reflection|
    reflection.associated_dataset.
      where(Sequel[:logic_mappings][:target_id] => id).
      or(Sequel[:logic_mappings][:source_id] => id)
  end), class: LogicMapping
end
