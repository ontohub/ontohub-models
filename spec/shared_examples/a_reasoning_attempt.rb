# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'a reasoning_attempt' do
  context 'associations' do
    before { subject.save }

    context 'action' do
      it_behaves_like('it has a', :action, Action)
      it_behaves_like('restricting the deletion of the association', :action)
    end

    context 'reasoner_configuration' do
      it_behaves_like('it has a', :reasoner_configuration,
                      ReasonerConfiguration)
      it_behaves_like('being deleted with the association',
                      :reasoner_configuration)
    end

    context 'used_logic_translation' do
      it_behaves_like('it has a', :used_logic_translation, LogicTranslation)
      it_behaves_like('being nullified with deletion of the association',
                      :used_logic_translation)
    end

    context 'used_reasoner' do
      it_behaves_like('it has a', :used_reasoner, Reasoner)
      it_behaves_like('being nullified with deletion of the association',
                      :used_reasoner)
    end
  end
end
