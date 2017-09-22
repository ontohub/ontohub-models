# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DocumentLink do
  context 'associations' do
    subject { create(:document_link) }

    context 'source' do
      it 'is a document' do
        expect(subject.source).to be_a(Document)
      end

      it_behaves_like('being deleted with the association', :source)
    end

    context 'target' do
      it 'is a document' do
        expect(subject.target).to be_a(Document)
      end

      it_behaves_like('being deleted with the association', :target)
    end
  end
end
