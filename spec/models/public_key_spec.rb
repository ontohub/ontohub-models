# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PublicKey, type: :model do
  context 'timestamps' do
    subject { build(:public_key) }
    it_behaves_like 'an object with timestamps'
  end

  context 'validations' do
    subject { build(:public_key) }

    it 'is valid' do
      expect(subject).to be_valid
    end

    context 'name' do
      it 'is invalid if the name is already taken' do
        create(:public_key, name: subject.name, user: subject.user)
        expect(subject).not_to be_valid
      end

      it 'is invalid if the name is not present' do
        subject.name = ''
        expect(subject).not_to be_valid
      end
    end

    context 'key' do
      it 'is invalid if the key is not present' do
        subject.key = ''
        expect(subject).not_to be_valid
      end
    end

    context 'user' do
      it 'is invalid if the user is not present' do
        subject.user = nil
        expect(subject).not_to be_valid
      end
    end
  end

  context 'fingerprint' do
    context 'valid key' do
      subject { create(:public_key) }

      it 'generates the fingerprint before saving' do
        expect(subject.fingerprint).not_to be_empty
      end
    end

    context 'invalid key' do
      subject { build(:public_key, key: 'ssh-rsa someinvalidkey') }

      before { subject.before_validation }

      it 'is nil' do
        expect(subject.fingerprint).to be_nil
      end
    end
  end
end
