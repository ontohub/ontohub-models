# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProofAttempt, type: :model do
  it_behaves_like 'having a number', :proof_attempt, :conjecture

  context 'superclass' do
    subject { build(:proof_attempt) }
    it_behaves_like 'a reasoning_attempt', :proof_attempt

    context 'conjecture' do
      it_behaves_like('it has a', :conjecture, Conjecture)
      it_behaves_like('being deleted with the association', :conjecture)
    end
  end
end
