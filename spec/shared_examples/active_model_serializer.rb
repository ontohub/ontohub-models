# frozen_string_literal: true

# This is the RSpec formulation of ActiveModel::Serializer::Lint::Tests
RSpec.shared_examples 'an ActiveModelSerializer compatible object' do
  it_behaves_like 'an ActiveModelSerializer compatible object with devise'

  describe '#serializable_hash' do
    it 'takes the correct number of arguments' do
      expect(subject.method(:serializable_hash).arity).to eq(0)
    end

    it 'is a Hash' do
      expect(subject.serializable_hash).to be_a(Hash)
    end
  end

  describe '.human_attribute_name' do
    it 'takes the correct number of arguments' do
      expect(subject.class.method(:human_attribute_name).arity).to eq(-2)
    end
  end
end
