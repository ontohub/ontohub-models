# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Signature do
  context 'associations' do
    subject { create(:signature) }

    context 'language' do
      it_behaves_like('it has a', :language, Language)
      it_behaves_like('being deleted with the association', :language)
    end

    context 'symbols' do
      # Make sure that there are unrelated objects that are not selected in the
      # association.
      let!(:unrelated) do
        unrelated_signature = create(:signature)
        symbols = (1..2).map { create(:symbol) }
        create(:signature_symbol,
               signature: unrelated_signature,
               symbol: symbols.first,
               imported: false)
        create(:signature_symbol,
               signature: unrelated_signature,
               symbol: symbols.last,
               imported: true)
        symbols
      end

      let!(:non_imported) do
        (1..2).map do
          create(:signature_symbol, signature: subject, imported: false).symbol
        end
      end

      let!(:imported) do
        (1..2).map do
          create(:signature_symbol, signature: subject, imported: true).symbol
        end
      end

      it 'has symbols' do
        expect(subject.symbols).to match_array(non_imported + imported)
      end

      it 'has non_imported_symbols' do
        expect(subject.non_imported_symbols).to match_array(non_imported)
      end

      it 'has imported_symbols' do
        expect(subject.imported_symbols).to match_array(imported)
      end
    end

    context 'signature_morphisms' do
      let!(:as_source) { create(:signature_morphism, source: subject) }
      let!(:as_target) { create(:signature_morphism, target: subject) }
      let!(:unrelated) { create(:signature_morphism) }

      context 'signature_morphisms_source' do
        it 'contains the signature_morphism' do
          expect(subject.signature_morphisms_source).to match_array([as_source])
        end
      end

      context 'signature_morphisms_target' do
        it 'contains the signature_morphism' do
          expect(subject.signature_morphisms_target).to match_array([as_target])
        end
      end

      context 'signature_morphisms' do
        it 'contains the signature_morphism' do
          expect(subject.signature_morphisms).
            to match_array([as_source, as_target])
        end
      end
    end
  end

  context 'methods' do
    subject { create(:signature) }

    context 'add_symbol' do
      [true, false].each do |imported|
        context "adding a symbol as #{imported ? '' : 'non-'}imported" do
          let(:symbol) { create(:symbol) }
          before do
            subject.add_symbol(symbol, imported)
          end

          it 'associates the symbol' do
            expect(subject.symbols).to match_array([symbol])
          end

          it 'marks the symbol correctly' do
            expect(SignatureSymbol.find(signature: subject, symbol: symbol).
                     imported).
              to be(imported)
          end
        end
      end
    end

    context 'remove_symbol' do
      let(:symbol) { create(:symbol) }
      before do
        subject.add_symbol(symbol, true)
        subject.remove_symbol(symbol)
      end

      it 'removes the association row' do
        expect(SignatureSymbol.find(signature: subject, symbol: symbol)).
          to be(nil)
      end
    end
  end
end
