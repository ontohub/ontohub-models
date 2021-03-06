# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'an organizational unit' do |factory|
  context 'validations' do
    subject { build factory }
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

        it 'with a blacklisted name is invalid' do
          subject.name = OrganizationalUnit::SLUG_BLACKLIST.sample
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

        it 'with a blacklisted name is valid' do
          subject.name = OrganizationalUnit::SLUG_BLACKLIST.sample
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

    context 'display_name' do
      it 'nil is valid' do
        expect(subject).to be_valid
      end

      it 'empty is valid' do
        subject.display_name = ''
        expect(subject).to be_valid
      end

      it 'with a long real name is valid' do
        subject.display_name = 'a' * 100
        expect(subject).to be_valid
      end

      it 'with too long of a real name is invalid' do
        subject.display_name = 'a' * 101
        expect(subject).not_to be_valid
      end
    end
  end

  context 'slug' do
    subject { build factory }

    it 'uses only the name as the slug' do
      subject.save
      expect(subject.slug).to eq(subject.name)
    end

    it_behaves_like 'an object that has a slug', ',' do
      let(:other_subject) { create(factory, name: subject.name) }
    end
  end

  context 'timestamps' do
    subject { build factory }
    it_behaves_like 'an object with timestamps'
  end
end
