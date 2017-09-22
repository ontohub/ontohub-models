# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReasonerOutput do
  context 'associations' do
    subject { create(:reasoner_output) }

    context 'reasoning_attempt' do
      it_behaves_like('it has a', :reasoning_attempt, ReasoningAttempt)
      it_behaves_like('being deleted with the association', :reasoning_attempt)
    end

    context 'reasoner' do
      it_behaves_like('it has a', :reasoner, Reasoner)
      it_behaves_like('being deleted with the association', :reasoner)
    end
  end
end
