# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SignatureSymbol do
  context 'mass assignment of associations' do
    it 'is allowed even though they are the primary key' do
      expect do
        SignatureSymbol.new(signature: create(:signature),
                            symbol: create(:symbol))
      end.not_to raise_error
    end
  end

  context 'associations' do
    subject { create(:signature_symbol) }

    context 'signature' do
      it_behaves_like('it has a', :signature, Signature)

      it_behaves_like('being deleted with the association', :signature,
                      %i(signature_id symbol_id))
    end

    context 'symbol' do
      it_behaves_like('it has a', :symbol, OMSSymbol)
      it_behaves_like('being deleted with the association', :symbol,
                      %i(signature_id symbol_id))
    end
  end
end
