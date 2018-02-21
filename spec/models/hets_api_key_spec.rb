# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HetsApiKey do
  context 'superclass' do
    subject { build(:hets_api_key) }
    it_behaves_like 'an ApiKey' do
      let(:factory) { :hets_api_key }
    end
  end
end
