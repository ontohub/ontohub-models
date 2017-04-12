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

  context 'validations' do
    it { is_expected.to validate_presence(:commit_sha) }
    it 'is invalid if the commit_sha is nil' do
      subject.commit_sha = nil
      expect(subject.valid?).to be(false)
    end
    it { is_expected.to validate_format(/\A[a-f0-9]{40}\z/, :commit_sha) }

    it { is_expected.to validate_presence(:path) }
    it 'is invalid if the path is nil' do
      subject.path = nil
      expect(subject.valid?).to be(false)
    end

    it { is_expected.to validate_presence(:repository) }
    it 'is invalid if the repository is nil' do
      subject.repository = nil
      expect(subject.valid?).to be(false)
    end
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

    it 'has a repository' do
      expect(subject.repository).to be_a(Repository)
    end
  end
end
