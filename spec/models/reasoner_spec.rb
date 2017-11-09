# frozen_string_literal: true

require 'rails_helper'

# This spec is only here to test if the factory works.
RSpec.describe Reasoner do
  subject { create(:reasoner) }

  context 'methods' do
    it_behaves_like 'an object that has a slug set externally'
  end
end
