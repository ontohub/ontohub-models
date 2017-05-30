# frozen_string_literal: true

require 'rails_helper'
require 'shared_examples/active_model'
require 'shared_examples/active_model_serializer'
require 'shared_examples/model_with_url'
require 'shared_examples/slug'

RSpec.describe Repository, type: :model do
  context 'validations' do
    subject { build :repository, name: Faker::Lorem.words(2).join(' ') }
    context 'name' do
      it 'is invalid without name' do
        subject.name = nil
        expect(subject.valid?).to be(false)
      end

      it 'is invalid with a name which is to short' do
        subject.name = 'fo'
        expect(subject.valid?).to be(false)
      end
    end

    context 'owner' do
      it 'is invalid if the owner is nil' do
        subject.owner = nil
        expect(subject.valid?).to be(false)
      end
    end

    context 'access' do
      it 'public access is nil' do
        subject.public_access = nil
        expect(subject.valid?).to be(false)
      end
    end

    context 'content' do
      %w(ontology model specification mathematical).each do |content_type|
        it "is valid with #{content_type} content type" do
          subject.content_type = content_type
          expect(subject.valid?).to be(true)
        end
      end

      it 'has a value that is not allowed' do
        subject.content_type = 'not_allowed'
        expect(subject.valid?).to be(false)
      end
    end
  end

  context 'compatibility' do
    subject { build :repository, name: Faker::Lorem.words(2).join(' ') }
    it_behaves_like 'an ActiveModel compatible object'
    it_behaves_like 'an ActiveModelSerializer compatible object'
  end

  context 'url' do
    subject { build :repository }
    it_behaves_like 'an object that has a URL'
  end

  context 'slug' do
    subject { build :repository, name: Faker::Lorem.words(2).join(' ') }

    it_behaves_like 'an object that has a slug', ',' do
      let(:other_subject) { create :repository, owner: subject.owner }
    end

    it "merges the owner's slug with the own name" do
      subject.save
      expect(subject.slug).
        to eq("#{subject.owner.slug}/"\
              "#{Slug.sluggify(subject.name)}")
    end
  end

  context 'file_versions' do
    subject { create(:repository, name: Faker::Lorem.words(2).join(' ')) }

    before do
      5.times do
        create(:file_version, repository: subject)
      end
    end

    it 'destroys the file_versions on destroy' do
      id = subject.id
      expect { subject.destroy }.
        to change { FileVersion.where(repository_id: id).count }.to(0)
    end
  end
end
