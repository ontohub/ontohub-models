# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'a conjecture' do
  it_behaves_like 'a sentence'

  context 'validations' do
    it 'is valid' do
      expect(subject).to be_valid
    end

    it 'is invalid if the evaluation_state is bad' do
      subject.evaluation_state = 'bad'
      expect(subject.valid?).to be(false)
    end

    it 'is invalid if the reasoning_status is bad' do
      subject.reasoning_status = 'bad'
      expect(subject.valid?).to be(false)
    end
  end

  context 'associations' do
    before { subject.save }

    context 'proof_attempts' do
      let!(:attempt1) { create(:proof_attempt, conjecture: subject) }
      let!(:attempt2) { create(:proof_attempt, conjecture: subject) }
      let!(:unrelated) { create(:proof_attempt) }

      it 'contains the proof_attempts' do
        expect(subject.proof_attempts).to match_array([attempt1, attempt2])
      end
    end
  end
end
