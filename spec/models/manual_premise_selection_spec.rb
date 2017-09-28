# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ManualPremiseSelection do
  context 'superclass' do
    subject { build(:manual_premise_selection) }
    it_behaves_like 'a premise_selection'
  end
end
