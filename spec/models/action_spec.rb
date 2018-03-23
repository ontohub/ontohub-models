# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Action, type: :model do
  context 'validations' do
    subject { build(:action) }

    it 'is valid' do
      expect(subject).to be_valid
    end

    it 'is invalid if the evaluation_state is nil' do
      subject.evaluation_state = nil
      expect(subject.valid?).to be(false)
    end

    it 'is invalid if the evaluation_state is bad' do
      subject.evaluation_state = 'bad'
      expect(subject.valid?).to be(false)
    end

    it 'is valid with a message' do
      subject = build(:action, :with_message)
      expect(subject.valid?).to be(true)
    end
  end

  context 'timestamps' do
    subject { build(:action) }
    it_behaves_like 'an object with timestamps'
  end
end
