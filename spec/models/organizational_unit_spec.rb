# frozen_string_literal: true

require 'rails_helper'

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
    context 'slug' do
      it { is_expected.to validate_unique(:slug) }
      it { is_expected.to validate_format(/\A[a-z0-9-]+\z/, :slug) }
    end
  end

  context 'slug' do
    let(:organizational_unit) do
      create :organizational_unit, name: Faker::Lorem.words(2).join(' ')
    end

    context 'on create' do
      it 'the slug is set correctly' do
        expect(organizational_unit.slug).
          to eq(organizational_unit.name.parameterize)
      end
    end

    context 'on update' do
      let!(:old_slug) { organizational_unit.slug }
      before do
        organizational_unit.name = "#{organizational_unit.name}_changed"
        organizational_unit.save
      end

      it 'the slug is not changed' do
        expect(organizational_unit.slug).to eq(old_slug)
      end
    end

    it 'exposes to_param correctly' do
      expect(organizational_unit.to_param).to eq(organizational_unit.slug)
    end
  end
end
