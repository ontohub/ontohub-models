# frozen_string_literal: true

# This is the RSpec formulation of ActiveModel::Lint::Tests
RSpec.shared_examples 'an ActiveModel compatible object' do
  describe '#to_key' do
    it 'reponds to the method' do
      expect(subject).to respond_to(:to_key)
    end

    it 'takes the correct number of arguments' do
      expect(subject.method(:to_key).arity).to eq(0)
    end

    it 'is nil for a non-persisted model' do
      allow(subject).to receive(:persisted?).and_return(false)
      expect(subject.to_key).to be(nil)
    end
  end

  describe '#to_param' do
    it 'reponds to the method' do
      expect(subject).to respond_to(:to_param)
    end

    it 'takes the correct number of arguments' do
      expect(subject.method(:to_param).arity).to eq(0)
    end

    it 'is nil for a non-persisted model' do
      allow(subject).to receive(:persisted?).and_return(false)
      allow(subject).to receive(:to_key).and_return([1])
      expect(subject.to_param).to be(nil)
    end
  end

  describe '#to_partial_path' do
    it 'reponds to the method' do
      expect(subject).to respond_to(:to_partial_path)
    end

    it 'takes the correct number of arguments' do
      expect(subject.method(:to_partial_path).arity).to eq(0)
    end

    it 'is a String' do
      expect(subject.to_partial_path).to be_a(String)
    end
  end

  describe '#persisted?' do
    it 'reponds to the method' do
      expect(subject).to respond_to(:persisted?)
    end

    it 'takes the correct number of arguments' do
      expect(subject.method(:persisted?).arity).to eq(0)
    end
  end

  describe '.model_name' do
    it 'reponds to the method' do
      expect(subject.class).to respond_to(:model_name)
    end

    it 'responds to #to_str' do
      expect(subject.model_name).to respond_to(:to_str)
    end

    it 'responds to #human#to_str' do
      expect(subject.model_name.human).to respond_to(:to_str)
    end

    it 'responds to #singular#to_str' do
      expect(subject.model_name.singular).to respond_to(:to_str)
    end

    it 'responds to #plural#to_str' do
      expect(subject.model_name.plural).to respond_to(:to_str)
    end
  end

  describe '#model_name' do
    it 'reponds to the method' do
      expect(subject).to respond_to(:model_name)
    end

    it "is equal to the class's model_name" do
      expect(subject.model_name).to eq(subject.class.model_name)
    end
  end

  describe '#errors' do
    it 'reponds to the method' do
      expect(subject).to respond_to(:errors)
    end
  end
end
