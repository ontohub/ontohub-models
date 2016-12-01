# frozen_string_literal: true

require 'rails_helper'
require 'shared_examples/active_model'
require 'shared_examples/active_model_serializer'
require 'shared_examples/model_with_url'
require 'shared_examples/slug'

RSpec.describe Repository, type: :model do
  context 'columns' do
    it { is_expected.to have_column(:name, type: :string) }
    it { is_expected.to have_column(:slug, type: :string) }
    it { is_expected.to have_column(:description, type: :string) }
    it { is_expected.to have_column(:created_at, type: :datetime) }
    it { is_expected.to have_column(:updated_at, type: :datetime) }
    it { is_expected.to have_column(:namespace_id, type: :integer) }
  end

  context 'validations' do
    subject { build :repository, name: Faker::Lorem.words(2).join(' ') }
    context 'name' do
      it { is_expected.to validate_presence(:name) }
      it { is_expected.to validate_length_range((3..100), :name) }
    end

    context 'namespace' do
      it { is_expected.to validate_presence(:namespace_id) }
      it 'is invalid if the namespace is nil' do
        subject.namespace = nil
        expect(subject.valid?).to be(false)
      end
    end

    context 'access' do
      it { is_expected.to validate_presence(:public_access) }
      it 'public access is nil' do
        subject.public_access = nil
        expect(subject.valid?).to be(false)
      end
    end

    context 'content' do
      it do
        is_expected.to validate_includes %w(ontology model specification),
          :content_type
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

    it_behaves_like 'an object that has a slug'

    it "merges the namespace's slug with the own name" do
      subject.save
      expect(subject.slug).
        to eq("#{subject.namespace.slug}/#{Slug.sluggify(subject.name)}")
    end
  end
end
