# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SineSymbolCommonness do
  context 'associations' do
    subject { create(:sine_symbol_commonness) }

    context 'sine_premise_selection' do
      it_behaves_like('it has a', :sine_premise_selection, SinePremiseSelection)
      it_behaves_like('being deleted with the association',
                      :sine_premise_selection)
    end

    context 'symbol' do
      it_behaves_like('it has a', :symbol, OMSSymbol)
      it_behaves_like('being deleted with the association', :symbol)
    end
  end
end
