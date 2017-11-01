# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReasonerConfiguration do
  context 'associations' do
    subject { create(:reasoner_configuration) }

    context 'configured_reasoner' do
      it_behaves_like('it has a', :configured_reasoner, Reasoner)

      it_behaves_like('being nullified with deletion of the association',
                      :configured_reasoner)
    end

    context 'reasoning_attempts' do
      let!(:unrelated) do
        (1..2).map { create(:proof_attempt) }
      end

      let!(:related) do
        (1..2).map do
          create(:proof_attempt, reasoner_configuration: subject)
        end
      end

      it 'has the reasoning_attempts' do
        expect(subject.reasoning_attempts).to match_array(related)
      end
    end

    context 'premise_selections' do
      let!(:unrelated) do
        (1..2).map { create(:premise_selection) }
      end

      let!(:related) do
        (1..2).map do
          create(:premise_selection, reasoner_configuration: subject)
        end
      end

      it 'has the premise_selections' do
        expect(subject.premise_selections).to match_array(related)
      end
    end
  end
end
