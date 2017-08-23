# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PublicKey, type: :model do
  context 'timestamps' do
    subject { build(:public_key) }
    it_behaves_like 'an object with timestamps'
  end
end
