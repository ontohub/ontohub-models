# frozen_string_literal: true

require 'rails_helper'
require 'shared_examples/slug'

RSpec.describe OrganizationalUnit, type: :model do
  context 'columns' do
    it { is_expected.to have_column(:name, type: :string) }
    it { is_expected.to have_column(:slug, type: :string) }
    it { is_expected.to have_column(:created_at, type: :datetime) }
    it { is_expected.to have_column(:updated_at, type: :datetime) }
  end

  context 'validations' do
    let(:organizational_unit) { build :organizational_unit }
    context 'name' do
      it { is_expected.to validate_presence(:name) }
      it { is_expected.to validate_length_range((3..100), :name) }
    end
  end

  context 'slug' do
    subject do
      build :organizational_unit, name: Faker::Lorem.words(2).join(' ')
    end

    it_behaves_like 'an object that has a slug'

    it 'uses only the name for the slug' do
      subject.save
      expect(subject.slug).to eq(Slug.sluggify(subject.name))
    end
  end

  context 'deletion' do
    subject { create :organizational_unit }

    before do
      subject.destroy
    end

    it 'removes the namespace' do
      expect(Namespace.all).to be_empty
    end
  end
end
