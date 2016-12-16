# frozen_string_literal: true

require 'rails_helper'
require 'shared_examples/active_model'
require 'shared_examples/active_model_serializer'
require 'shared_examples/model_with_url'

RSpec.describe Commit, type: :model do
  context 'columns' do
    it { is_expected.to have_column(:created_at, type: :datetime) }
    it { is_expected.to have_column(:updated_at, type: :datetime) }
    it { is_expected.to have_column(:repository_id, type: :integer) }
    it { is_expected.to have_column(:author_id, type: :integer) }
    it { is_expected.to have_column(:editor_id, type: :integer) }
    it { is_expected.to have_column(:pusher_id, type: :integer) }
    it { is_expected.to have_column(:author_name, type: :string) }
    it { is_expected.to have_column(:editor_name, type: :string) }
    it { is_expected.to have_column(:author_email, type: :string) }
    it { is_expected.to have_column(:editor_email, type: :string) }
    it { is_expected.to have_column(:authored_at, type: :datetime) }
    it { is_expected.to have_column(:edited_at, type: :datetime) }
    it { is_expected.to have_column(:shasum, type: :string) }
  end

  context 'validations' do
    context 'pusher' do
      it { is_expected.to validate_presence(:pusher) }
      context 'check' do
        subject { build :commit, pusher: nil }
        it 'is invalid' do
          expect(subject.valid?).to eq(false)
        end

        it 'sets the correct error' do
          subject.valid?
          expect(subject.errors[:pusher]).not_to be_empty
        end
      end
    end
  end

  context 'url' do
    subject { build :commit }
    it_behaves_like 'an object that has a URL'
  end

  context 'compatibility' do
    subject { build :commit }
    it_behaves_like 'an ActiveModel compatible object'
    it_behaves_like 'an ActiveModelSerializer compatible object'
  end

  context 'associations' do
    subject do
      build :commit, repository: nil, author: nil, editor: nil, pusher: nil
    end
    let(:repository) { create :repository }
    let(:author) { create :user }
    let(:editor) { create :user }
    let(:pusher) { create :user }

    it 'can set a repository' do
      repository.save
      subject.repository = repository
      expect(subject.repository).to be(repository)
    end

    it 'can set an author' do
      author.save
      subject.author = author
      expect(subject.author).to be(author)
    end

    it 'can set an editor' do
      editor.save
      subject.editor = editor
      expect(subject.editor).to be(editor)
    end

    it 'can set a pusher' do
      pusher.save
      subject.pusher = pusher
      expect(subject.pusher).to be(pusher)
    end
  end

  context 'author and editor' do
    subject { create :commit, author: nil, editor: nil }
    let(:author) { create :user }
    let(:editor) { create :user }

    it 'can set author automatically' do
      subject.author_email = author.email
      subject.save
      expect(subject.author).to eq(author)
    end

    it 'can set editor automatically' do
      subject.editor_email = editor.email
      subject.save
      expect(subject.editor).to eq(editor)
    end
  end
end
