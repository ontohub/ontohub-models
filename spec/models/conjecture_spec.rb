# frozen_string_literal: true

require 'rails_helper'

# This spec is only here to test if the factory works.
RSpec.describe Conjecture do
  subject { create(:conjecture) }

  it 'is a Conjecture' do
    expect(subject).to be_a(Conjecture)
  end
end
