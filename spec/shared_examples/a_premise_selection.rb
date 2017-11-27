# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'a premise_selection' do
  context 'associations' do
    before { subject.save }

    context 'reasoner_configuration' do
      it_behaves_like('it has a', :reasoner_configuration,
                      ReasonerConfiguration)
      it_behaves_like('being deleted with the association',
                      :reasoner_configuration)
    end

    context 'repositories' do
      let!(:unrelated) do
        (1..2).map { create(:proof_attempt).repository }
      end

      let!(:related) do
        (1..2).map do
          create(:proof_attempt,
                 reasoner_configuration: subject.reasoner_configuration).
            repository
        end
      end

      it 'has the reasoning_attempts' do
        expect(subject.repositories).to match_array(related)
      end
    end

    context 'selected_premises' do
      let!(:unrelated) do
        (1..2).map { create(:sentence) }
      end

      let!(:related) do
        sentences = (1..2).map { create(:sentence) }
        sentences.each do |sentence|
          subject.add_selected_premise(sentence)
        end
        sentences
      end

      it 'has the selected_premises' do
        expect(subject.selected_premises).to match_array(related)
      end
    end
  end
end
