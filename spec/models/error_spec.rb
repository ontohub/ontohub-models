# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Error do
  context 'superclass' do
    subject { build(:error) }
    it_behaves_like 'a diagnosis'
  end
end
