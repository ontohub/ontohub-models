# frozen_string_literal: true

require 'rails_helper'

# This spec is only here to test if the factory works.
RSpec.describe Reasoner do
  subject { create(:reasoner) }

  it 'is a Reasoner' do
    expect(subject).to be_a(Reasoner)
  end
end
