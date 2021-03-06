# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LogicMapping do
  context 'timestamps' do
    subject { build(:logic_mapping) }
    it_behaves_like 'an object with timestamps'
  end

  context 'associations' do
    subject { create(:logic_mapping) }

    context 'language_mapping' do
      it_behaves_like('it has a', :language_mapping, LanguageMapping)
      it_behaves_like('being deleted with the association', :language_mapping)
    end

    context 'source' do
      it_behaves_like('it has a', :source, Logic)
      it_behaves_like('being deleted with the association', :source)
    end

    context 'target' do
      it_behaves_like('it has a', :target, Logic)
      it_behaves_like('being deleted with the association', :target)
    end
  end

  context 'methods' do
    subject { create(:logic_mapping) }
    it_behaves_like 'an object that has a slug set externally'
  end
end
