# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConsistencyCheckAttempt, type: :model do
  context 'superclass' do
    subject { build(:consistency_check_attempt) }
    it_behaves_like 'a reasoning_attempt', :consistency_check_attempt
  end
end
