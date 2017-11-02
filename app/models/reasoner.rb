# frozen_string_literal: true

# The Reasoner (Prover or Consistency Checker)
class Reasoner < Sequel::Model
  def to_param
    slug
  end
end
