# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'a reasoning_attempt' do
  context 'validations' do
    it 'is valid' do
      expect(subject).to be_valid
    end

    it 'is invalid if the evaluation_state is bad' do
      subject.evaluation_state = 'bad'
      expect(subject.valid?).to be(false)
    end

    it 'is invalid if the reasoning_status is bad' do
      subject.reasoning_status = 'bad'
      expect(subject.valid?).to be(false)
    end
  end

  context 'associations' do
    before { subject.save }

    context 'reasoner_configuration' do
      it_behaves_like('it has a', :reasoner_configuration,
                      ReasonerConfiguration)
      it_behaves_like('being deleted with the association',
                      :reasoner_configuration)
    end

    context 'used_logic_mapping' do
      it_behaves_like('it has a', :used_logic_mapping, LogicMapping)
      it_behaves_like('being nullified with deletion of the association',
                      :used_logic_mapping)
    end

    context 'used_reasoner' do
      it_behaves_like('it has a', :used_reasoner, Reasoner)
      it_behaves_like('being nullified with deletion of the association',
                      :used_reasoner)
    end
  end
end
