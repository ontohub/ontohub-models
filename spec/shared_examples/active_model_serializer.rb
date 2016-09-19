# frozen_string_literal: true

require 'json'

# This is the RSpec formulation of ActiveModel::Serializer::Lint::Tests
RSpec.shared_examples 'an ActiveModelSerializer compatible object' do
  describe '#serializable_hash' do
    it 'reponds to the method' do
      expect(subject).to respond_to(:serializable_hash)
    end

    it 'takes the correct number of arguments' do
      expect(subject.method(:serializable_hash).arity).to eq(0)
    end

    it 'is a Hash' do
      expect(subject.serializable_hash).to be_a(Hash)
    end
  end

  describe '#read_attribute_for_serialization' do
    it 'reponds to the method' do
      expect(subject).to respond_to(:read_attribute_for_serialization)
    end

    it 'takes the correct number of arguments' do
      expect(subject.method(:read_attribute_for_serialization).arity).to eq(1)
    end

    it 'is the id when called with id' do
      expect(subject.read_attribute_for_serialization(:id)).to eq(subject.id)
    end
  end

  describe '#as_json' do
    it 'reponds to the method' do
      expect(subject).to respond_to(:as_json)
    end

    it 'takes the correct number of arguments' do
      expect(subject.method(:as_json).arity).to eq(-1)
    end

    it 'is a Hash' do
      expect(subject.as_json).to be_a(Hash)
    end

    it 'is a Hash when called with nil' do
      expect(subject.as_json(nil)).to be_a(Hash)
    end
  end

  describe '#to_json' do
    it 'reponds to the method' do
      expect(subject).to respond_to(:to_json)
    end

    it 'takes the correct number of arguments' do
      expect(subject.method(:to_json).arity).to eq(-1)
    end

    it 'is a JSON String' do
      expect(JSON.parse(subject.to_json)).to be_a(Hash)
    end

    it 'is a JSON String when called with nil' do
      expect(JSON.parse(subject.to_json(nil))).to be_a(Hash)
    end
  end

  describe '#cache_key' do
    it 'reponds to the method' do
      expect(subject).to respond_to(:cache_key)
    end

    it 'takes the correct number of arguments' do
      expect(subject.method(:cache_key).arity).to eq(0)
    end

    it 'is a String' do
      expect(subject.cache_key).to be_a(String)
    end
  end

  describe '#updated_at' do
    it 'reponds to the method' do
      expect(subject).to respond_to(:updated_at)
    end

    it 'takes the correct number of arguments' do
      expect(subject.method(:updated_at).arity).to eq(0)
    end
  end

  describe '#id' do
    it 'reponds to the method' do
      expect(subject).to respond_to(:id)
    end

    it 'takes the correct number of arguments' do
      expect(subject.method(:id).arity).to eq(0)
    end
  end

  describe '.model_name' do
    it 'reponds to the method' do
      expect(subject.class).to respond_to(:model_name)
    end

    it 'takes the correct number of arguments' do
      expect(subject.class.method(:model_name).arity).to eq(0)
    end

    it 'is a ActiveModel::Name' do
      expect(subject.class.model_name).to be_a(ActiveModel::Name)
    end
  end

  describe '#errors' do
    it 'reponds to the method' do
      expect(subject).to respond_to(:errors)
    end

    it 'takes the correct number of arguments' do
      expect(subject.method(:errors).arity).to eq(0)
    end

    it 'is a Hash' do
      expect(subject.errors).to be_a(Hash)
    end

    describe '#messages' do
      it 'responds to the method' do
        expect(subject.errors).to respond_to(:messages)
      end

      it 'takes the correct number of arguments' do
        expect(subject.errors.method(:messages).arity).to eq(0)
      end

      it 'is a Hash' do
        expect(subject.errors.messages).to be_a(Hash)
      end
    end
  end

  describe '.human_attribute_name' do
    it 'reponds to the method' do
      expect(subject.class).to respond_to(:human_attribute_name)
    end

    it 'takes the correct number of arguments' do
      expect(subject.class.method(:human_attribute_name).arity).to eq(-2)
    end
  end

  describe '.lookup_ancestors' do
    it 'reponds to the method' do
      expect(subject.class).to respond_to(:lookup_ancestors)
    end

    it 'takes the correct number of arguments' do
      expect(subject.class.method(:lookup_ancestors).arity).to eq(0)
    end
  end
end
