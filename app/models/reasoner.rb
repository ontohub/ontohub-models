# frozen_string_literal: true

# The Reasoner (Prover or Consistency Checker)
class Reasoner < Sequel::Model
  plugin :single_table_inheritance, :kind

  def to_param
    slug
  end
end
