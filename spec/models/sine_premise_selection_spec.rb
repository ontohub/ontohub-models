# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SinePremiseSelection do
  context 'superclass' do
    subject { build(:sine_premise_selection) }
    it_behaves_like 'a premise_selection'
  end
end
