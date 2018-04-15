# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'a sentence' do
  context 'associations' do
    before { subject.save }

    context 'repository' do
      it_behaves_like('it has a', :repository, Repository)
      it_behaves_like('being deleted with the association', :repository)
    end

    context 'oms' do
      it_behaves_like('it has a', :oms, OMS)
      it_behaves_like('being deleted with the association', :oms)
    end

    context 'original_sentence' do
      before do
        subject.original_sentence_id = create(:sentence).id
        subject.save
      end

      it_behaves_like('it has a', :original_sentence, Sentence)
      it_behaves_like('being nullified with deletion of the association',
                      :original_sentence)
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
