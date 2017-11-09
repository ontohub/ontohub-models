# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'a conjecture' do
  it_behaves_like 'a sentence'

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
