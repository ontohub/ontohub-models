# frozen_string_literal: true

require 'rails_helper'

# This spec is only here to test if the factory works.
RSpec.describe ConservativityStatus do
  subject { create(:conservativity_status) }

  it 'is a ConservativityStatus' do
    expect(subject).to be_a(ConservativityStatus)
  end
end
