# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SignatureMorphism do
  context 'associations' do
    subject { create(:signature_morphism) }

    context 'logic_mapping' do
      it_behaves_like('it has a', :logic_mapping, LogicMapping)
      it_behaves_like('being deleted with the association', :logic_mapping)
    end

    context 'source' do
      it_behaves_like('it has a', :source, Signature)
      it_behaves_like('being deleted with the association', :source)
    end

    context 'target' do
      it_behaves_like('it has a', :target, Signature)
      it_behaves_like('being deleted with the association', :target)
    end

    context 'mappings' do
      let!(:unrelated) { create(:mapping) }
      let!(:related) { create(:mapping, signature_morphism: subject) }

      it 'contains the related object' do
        expect(subject.mappings).to match_array([related])
      end
    end

    context 'symbol_mappings' do
      let!(:unrelated) { create(:symbol_mapping) }
      let!(:related) { create(:symbol_mapping, signature_morphism: subject) }

      it 'contains the related object' do
        expect(subject.symbol_mappings).to match_array([related])
      end
    end

    context 'repositories' do
      let!(:repository1) { create(:oms, signature: subject.source).repository }
      let!(:repository2) { create(:oms, signature: subject.source).repository }
      let!(:repository3) { create(:oms, signature: subject.target).repository }
      let!(:repository4) { create(:oms, signature: subject.target).repository }
      let!(:unrelated_repository) { create(:repository) }
      let!(:unrelated_signature_morphism) { create(:signature_morphism) }

      it 'contains the repositories' do
        expect(subject.repositories).
          to match_array([repository1, repository2, repository3, repository4])
      end
    end
  end
end
