# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Hint do
  context 'superclass' do
    subject { build(:hint) }
    it_behaves_like 'a diagnosis'
  end
end
