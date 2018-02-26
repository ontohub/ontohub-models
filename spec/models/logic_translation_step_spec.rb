# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LogicTranslationStep do
  context 'associations' do
    subject { create(:logic_translation_step) }

    context 'logic_translation' do
      it_behaves_like('it has a', :logic_translation, LogicTranslation)
      it_behaves_like('being deleted with the association', :logic_translation)
    end

    context 'logic_mapping' do
      subject { create(:logic_translation_step, :with_logic_mapping) }
      it_behaves_like('it has a', :logic_mapping, LogicMapping)
      it_behaves_like('being deleted with the association', :logic_mapping)
    end

    context 'logic_inclusion' do
      subject { create(:logic_translation_step, :with_logic_inclusion) }
      it_behaves_like('it has a', :logic_inclusion, LogicInclusion)
      it_behaves_like('being deleted with the association', :logic_inclusion)
    end
  end
end
