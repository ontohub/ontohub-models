# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'a sentence' do
  context 'associations' do
    before { subject.save }

    context 'oms' do
      it_behaves_like('it has a', :oms, OMS)
      it_behaves_like('being deleted with the association', :oms)
    end

    it_behaves_like 'having a file_range'

    context 'symbols' do
      let!(:unrelated) do
        (1..2).map { create(:symbol) }
      end

      let!(:related) do
        symbols = (1..2).map { create(:symbol) }
        symbols.each do |symbol|
          subject.add_symbol(symbol)
        end
        symbols
      end

      it 'has the symbols' do
        expect(subject.symbols).to match_array(related)
      end
    end
  end
end
