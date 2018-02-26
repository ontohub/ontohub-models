# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProofAttempt, type: :model do
  subject { build(:proof_attempt) }
  it_behaves_like 'having a number', :proof_attempt, :conjecture

  context 'validations' do
    it 'is valid' do
      expect(subject).to be_valid
    end

    it 'is invalid if the proof_status is bad' do
      subject.proof_status = 'CONTR'
      expect(subject.valid?).to be(false)
    end
  end

  context 'superclass' do
    subject { create(:proof_attempt) }
    it_behaves_like 'a reasoning_attempt'

    context 'conjecture' do
      it_behaves_like('it has a', :conjecture, Conjecture)
      it_behaves_like('being deleted with the association', :conjecture)
    end
  end

  context 'associations' do
    subject { create(:proof_attempt) }

    context 'repository' do
      it_behaves_like('it has a', :repository, Repository)
      it_behaves_like('being deleted with the association', :repository)
    end
  end
end
