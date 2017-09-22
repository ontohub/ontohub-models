# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProofAttempt, type: :model do
  context 'superclass' do
    subject { build(:proof_attempt) }
    it_behaves_like 'a reasoning_attempt', :proof_attempt
  end
end
