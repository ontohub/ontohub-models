# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GitShellApiKey do
  context 'superclass' do
    subject { build(:git_shell_api_key) }
    it_behaves_like 'an ApiKey' do
      let(:factory) { :git_shell_api_key }
    end
  end
end
