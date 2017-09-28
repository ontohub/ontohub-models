# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Warn do
  context 'superclass' do
    subject { build(:warn) }
    it_behaves_like 'a diagnosis'
  end
end
