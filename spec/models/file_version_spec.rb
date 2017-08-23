# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FileVersion, type: :model do
  context 'validations' do
    subject { build :file_version }
    it 'is valid' do
      expect(subject).to be_valid
    end

    it 'is invalid if the commit_sha is nil' do
      subject.commit_sha = nil
      expect(subject.valid?).to be(false)
    end

    it 'is invalid with the wrong commit_sha format' do
      subject.commit_sha = '123'
      expect(subject.valid?).to be(false)
    end

    it 'is invalid without path' do
      subject.path = nil
      expect(subject.valid?).to be(false)
    end

    it 'is invalid if the path is nil' do
      subject.path = nil
      expect(subject.valid?).to be(false)
    end

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
