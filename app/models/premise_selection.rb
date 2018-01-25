# frozen_string_literal: true

# The PremiseSelection model
class PremiseSelection < Sequel::Model
  plugin :class_table_inheritance, key: :kind, alias: :premise_selections

  many_to_one :proof_attempt
  many_to_one :reasoner_configuration
  many_to_many :selected_premises, join_table: :premise_selected_sentences,
                                   left_key: :premise_selection_id,
                                   right_key: :premise_id,
                                   class: Sentence

  delegate :repositories, to: :reasoner_configuration
end
