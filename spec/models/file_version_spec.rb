# frozen_string_literal: true

require 'rails_helper'
require 'shared_examples/active_model'
require 'shared_examples/active_model_serializer'
require 'shared_examples/model_with_url'

RSpec.describe FileVersion, type: :model do
  context 'columns' do
    it { is_expected.to have_column(:created_at, type: :datetime) }
    it { is_expected.to have_column(:updated_at, type: :datetime) }
    it { is_expected.to have_column(:commit_id, type: :integer) }
    it { is_expected.to have_column(:path, type: :string) }
  end

  context 'validations' do
    context 'commit' do
      it { is_expected.to validate_presence(:commit) }
      context 'check' do
        subject { build :file_version, commit: nil }
        it 'is invalid' do
          expect(subject.valid?).to eq(false)
        end

        it 'sets the correct error' do
          subject.valid?
          expect(subject.errors[:commit]).not_to be_empty
        end
      end
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
    subject { build :file_version, commit: nil }
    let(:commit) { create :commit }
    it 'adds a commit' do
      subject.commit = commit
      expect(subject.commit).to be(commit)
    end
  end
end
