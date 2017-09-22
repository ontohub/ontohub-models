# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GeneratedAxiom do
  context 'associations' do
    subject { create(:generated_axiom) }

    context 'reasoning_attempt' do
      it_behaves_like('it has a', :reasoning_attempt, ReasoningAttempt)
      it_behaves_like('being deleted with the association', :reasoning_attempt)
    end
  end
end
