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

    it 'is valid if it has an action' do
      subject.action = create(:action)
      expect(subject.valid?).to be(true)
    end
  end

  context 'compatibility' do
    subject { build :file_version }
    it_behaves_like 'an ActiveModel compatible object'
    it_behaves_like 'an ActiveModelSerializer compatible object'
  end

  context 'timestamps' do
    subject { build(:file_version) }
    it_behaves_like 'an object with timestamps'
  end

  context 'file version' do
    subject { build :file_version }

    it 'has a repository' do
      expect(subject.repository).to be_a(Repository)
    end
  end

  context 'associations' do
    subject { create(:file_version) }

    context 'action' do
      it_behaves_like('it has a', :action, Action)
      it_behaves_like('restricting the deletion of the association', :action)
    end

    context 'diagnoses' do
      let!(:unrelated) do
        (1..2).map { create(:diagnosis) }
      end

      let!(:related) do
        (1..2).map { create(:diagnosis, file_version: subject) }
      end

      it 'has the diagnoses' do
        expect(subject.diagnoses).to match_array(related)
      end
    end

    context 'repository' do
      it_behaves_like('it has a', :repository, Repository)
      it_behaves_like('being deleted with the association', :repository)
    end
  end
end
