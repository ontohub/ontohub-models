# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SymbolMapping do
  context 'associations' do
    subject { create(:symbol_mapping) }

    context 'signature_morphism' do
      it_behaves_like('it has a', :signature_morphism, SignatureMorphism)
      it_behaves_like('being deleted with the association', :signature_morphism)
    end

    context 'source' do
      it_behaves_like('it has a', :source, OMSSymbol)
      it_behaves_like('being deleted with the association', :source)
    end

    context 'target' do
      it_behaves_like('it has a', :target, OMSSymbol)
      it_behaves_like('being deleted with the association', :target)
    end
  end
end
