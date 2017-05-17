# frozen_string_literal: true

require 'rails_helper'
require 'shared_examples/model_with_url'
require 'shared_examples/slug'

RSpec.describe OrganizationalUnit, type: :model do
  context 'columns' do
    it { is_expected.to have_column(:slug, type: :string) }
    it { is_expected.to have_column(:real_name, type: :string) }
    it { is_expected.to have_column(:created_at, type: :datetime) }
    it { is_expected.to have_column(:updated_at, type: :datetime) }
  end

  context 'validations' do
    subject { build :organizational_unit }
    context 'name' do
      context 'new record' do
        it 'with a correct name is valid' do
          expect(subject).to be_valid
        end

        it 'with a short name is valid' do
          subject.name = 'a' * 3
          expect(subject).to be_valid
        end

        it 'with a long name is valid' do
          subject.name = 'a' * 100
          expect(subject).to be_valid
        end

        it 'with no name is invalid' do
          subject.name = nil
          expect(subject).not_to be_valid
        end

        it 'with too short of a name is invalid' do
          subject.name = 'a' * 2
          expect(subject).not_to be_valid
        end

        it 'with too long of a name is invalid' do
          subject.name = 'a' * 101
          expect(subject).not_to be_valid
        end
      end

      context 'saved record' do
        before { subject.save }

        it 'with a correct name is valid' do
          expect(subject).to be_valid
        end

        it 'with a short name is valid' do
          subject.name = 'a' * 3
          expect(subject).to be_valid
        end

        it 'with a long name is valid' do
          subject.name = 'a' * 100
          expect(subject).to be_valid
        end

        it 'with no name is valid' do
          subject.name = nil
          expect(subject).to be_valid
        end

        it 'with too short of a name is valid' do
          subject.name = 'a' * 2
          expect(subject).to be_valid
        end

        it 'with too long of a name is valid' do
          subject.name = 'a' * 101
          expect(subject).to be_valid
        end
      end
    end

    context 'real_name' do
      it 'nil is valid' do
        expect(subject).to be_valid
      end

      it 'empty is valid' do
        subject.real_name = ''
        expect(subject).to be_valid
      end

      it 'with a long real name is valid' do
        subject.real_name = 'a' * 100
        expect(subject).to be_valid
      end

      it 'with too long of a real name is invalid' do
        subject.real_name = 'a' * 101
        expect(subject).not_to be_valid
      end
    end
  end

  context 'url' do
    subject { build :organizational_unit }
    it_behaves_like 'an object that has a URL'
  end

  context 'slug' do
    subject { build :organizational_unit }
    it_behaves_like 'an object that has a slug'

    it 'uses only the name as the slug' do
      subject.save
      expect(subject.slug).to eq(subject.name)
    end
  end
end
