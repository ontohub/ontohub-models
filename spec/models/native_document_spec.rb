# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NativeDocument do
  context 'superclass' do
    subject { build(:native_document) }
    it_behaves_like 'a document'
  end

  context 'associations' do
    subject { create(:native_document) }

    context 'oms' do
      let!(:related) { create(:oms, document: subject) }

      it 'is the related object' do
        expect(subject.oms).to eq(related)
      end
    end
  end
end
