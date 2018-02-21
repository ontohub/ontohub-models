# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'an ApiKey' do
  context 'timestamps' do
    it_behaves_like 'an object with timestamps'
  end

  context '.generate' do
    let(:secret) { Faker::Crypto.md5 }
    let(:length) { 10 }
    let(:key) { described_class.generate(secret, length) }

    it 'contains an encoded and a raw key' do
      expect(key).to match(encoded: be_present, raw: be_present)
    end

    it 'creates an encoded key that is sha256 digested' do
      expect(key[:encoded]).to match(/[0-9a-f]{64}/)
    end

    (11..14).each do |key_length|
      context "with length #{key_length}" do
        let(:length) { key_length }

        it 'creates a raw key with a fitting length' do
          expect(key[:raw].length).to be_between(length - 1, length).inclusive
        end
      end
    end
  end

  context '.verify' do
    let(:secret) { Faker::Crypto.md5 }
    let(:length) { 10 }
    let(:key) { described_class.generate(secret, length) }
    let!(:api_key) { create(factory, key: key[:encoded]) }

    shared_examples 'it is invalid' do
      it 'does not verify' do
        expect(described_class.verify(user_secret, user_key)).to be(nil)
      end
    end

    shared_examples 'it is valid' do
      it 'validates' do
        expect(described_class.verify(user_secret, user_key)).to eq(api_key)
      end
    end

    context 'when the secret is valid' do
      let(:user_secret) { secret }

      context 'when the key is valid' do
        let(:user_key) { key[:raw] }
        include_examples 'it is valid'
      end

      context 'when the key is invalid' do
        let(:user_key) { "bad-#{key[:raw]}" }
        include_examples 'it is invalid'
      end
    end

    context 'when the secret is invalid' do
      let(:user_secret) { "bad-#{secret}" }

      context 'when the key is valid' do
        let(:user_key) { key[:raw] }
        include_examples 'it is invalid'
      end

      context 'when the key is invalid' do
        let(:user_key) { "bad-#{key[:raw]}" }
        include_examples 'it is invalid'
      end
    end
  end
end
