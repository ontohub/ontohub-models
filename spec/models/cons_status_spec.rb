# frozen_string_literal: true

require 'rails_helper'

# This spec is only here to test if the factory works.
RSpec.describe ConsStatus do
  subject { create(:cons_status) }

  it 'is a ConsStatus' do
    expect(subject).to be_a(ConsStatus)
  end
end
