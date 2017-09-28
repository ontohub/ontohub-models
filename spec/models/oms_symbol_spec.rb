# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OMSSymbol, type: :model do
  context 'superclass' do
    subject { build(:symbol) }
    it_behaves_like 'a loc_id_base'
  end

  context 'associations' do
    subject { create(:symbol) }

    context 'oms' do
      it_behaves_like('it has a', :oms, OMS)
      it_behaves_like('being deleted with the association', :oms)
    end

    it_behaves_like 'having a file_range'

    context 'sentences' do
      let!(:unrelated) do
        (1..2).map { create(:sentence) }
      end

      let!(:related) do
        sentences = (1..2).map { create(:sentence) }
        sentences.each do |sentence|
          subject.add_sentence(sentence)
        end
        sentences
      end

      it 'has the sentences' do
        expect(subject.sentences).to match_array(related)
      end
    end

    context 'signatures' do
      let!(:unrelated) do
        (1..2).map { create(:signature) }
      end

      let!(:related) do
        signatures = (1..2).map { create(:signature) }
        signatures.each do |signature|
          signature.add_symbol(subject, false)
        end
        signatures
      end

      it 'has the signatures' do
        expect(subject.signatures).to match_array(related)
      end
    end
  end
end
