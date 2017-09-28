# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Debug do
  context 'superclass' do
    subject { build(:debug) }
    it_behaves_like 'a diagnosis'
  end
end
