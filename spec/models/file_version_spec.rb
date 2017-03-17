# frozen_string_literal: true

require 'rails_helper'
require 'shared_examples/active_model'
require 'shared_examples/active_model_serializer'
require 'shared_examples/model_with_url'

RSpec.describe FileVersion, type: :model do
  context 'columns' do
    it { is_expected.to have_column(:commit_sha, type: :string) }
    it { is_expected.to have_column(:path, type: :string) }
  end

  context 'url' do
    subject { build :file_version }
    it_behaves_like 'an object that has a URL'
  end

  context 'compatibility' do
    subject { build :file_version }
    it_behaves_like 'an ActiveModel compatible object'
    it_behaves_like 'an ActiveModelSerializer compatible object'
  end

  context 'file version' do
    subject { build :file_version }
  end
end
