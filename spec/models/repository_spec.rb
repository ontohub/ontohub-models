# frozen_string_literal: true

require 'rails_helper'
require 'shared_examples/active_model'
require 'shared_examples/active_model_serializer'

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
    context 'name' do
      it { is_expected.to validate_presence(:name) }
      it { is_expected.to validate_length_range((3..100), :name) }
    end

    context 'slug' do
      it { is_expected.to validate_unique(:slug) }
      it { is_expected.to validate_format(/\A[a-z0-9\-_]+\z/, :slug) }
    end

    context 'namespace' do
      it { is_expected.to validate_presence(:namespace_id) }
    end
  end

  context 'compatibility' do
    subject { build :repository, name: Faker::Lorem.words(2).join(' ') }
    it_behaves_like 'an ActiveModel compatible object'
    it_behaves_like 'an ActiveModelSerializer compatible object'
  end

  context 'slug' do
    let(:repository) do
      create :repository, name: Faker::Lorem.words(2).join(' ')
    end
    subject { repository }

    context 'on create' do
      it 'the slug is set correctly' do
        expect(subject.slug).to eq(subject.name.parameterize)
      end
    end

    context 'on update' do
      let!(:old_slug) { subject.slug }
      before do
        subject.name = "#{subject.name}_changed"
        subject.save
      end

      it 'the slug is not changed' do
        expect(subject.slug).to eq(old_slug)
      end
    end

    it 'exposes to_param correctly' do
      expect(subject.to_param).to eq(subject.slug)
    end
  end
end
