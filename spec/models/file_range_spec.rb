# frozen_string_literal: true

require 'rails_helper'

# This spec is only here to test if the factory works.
RSpec.describe FileRange do
  subject { create(:file_range) }

  it 'is a FileRange' do
    expect(subject).to be_a(FileRange)
  end
end
