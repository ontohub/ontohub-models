require 'rails_helper'

RSpec.describe Repository, type: :model do
  context 'columns' do
    it { is_expected.to have_column(:name, type: :string) }
    it { is_expected.to have_column(:slug, type: :string) }
    it { is_expected.to have_column(:description, type: :string) }
    it { is_expected.to have_column(:created_at, type: :datetime) }
    it { is_expected.to have_column(:updated_at, type: :datetime) }
  end

  context 'validations' do
    let(:repository) { build :repository }
    context 'name' do
      it { is_expected.to validate_presence(:name) }
      it { is_expected.to validate_length_range((3..100), :name) }
    end
    context 'slug' do
      it { is_expected.to validate_unique(:slug) }
      it { is_expected.to validate_format(/\A[a-z0-9-]+\z/, :slug) }
    end
  end

  context 'slug' do
    let(:repository) { create :repository, name: Faker::Lorem.words(2).join(' ') }
    context 'on create' do
      it 'the slug is set correctly' do
        expect(repository.slug).to eq(repository.name.parameterize)
      end
    end

    context 'on update' do
      let!(:old_slug) { repository.slug }
      before do
        repository.name = "#{repository.name}_changed"
        repository.save
      end

      it 'the slug is not changed' do
        expect(repository.slug).to eq(old_slug)
      end
    end
  end
end