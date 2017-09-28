# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'a document' do
  context 'superclass' do
    it_behaves_like 'a loc_id_base'
  end

  context 'associations' do
    before { subject.save }

    context 'document_links' do
      let!(:as_source) { create(:document_link, source: subject) }
      let!(:as_target) { create(:document_link, target: subject) }
      let!(:unrelated) { create(:document_link) }

      context 'document_links_source' do
        it 'contains the document_link' do
          expect(subject.document_links_by_source).to match_array([as_source])
        end
      end

      context 'document_links_target' do
        it 'contains the document_link' do
          expect(subject.document_links_by_target).to match_array([as_target])
        end
      end

      context 'document_links' do
        it 'contains the document_links' do
          expect(subject.document_links).
            to match_array([as_source, as_target])
        end
      end
    end
  end
end
