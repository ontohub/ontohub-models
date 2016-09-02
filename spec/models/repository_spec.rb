require 'rails_helper'

RSpec.describe Repository, type: :model do
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
