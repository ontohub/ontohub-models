# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Library do
  context 'superclass' do
    subject { build(:library) }
    it_behaves_like 'a document'
  end

  context 'associations' do
    subject { create(:library) }

    context 'oms' do
      let!(:related) { create(:oms, document: subject) }
      let!(:unrelated) { create(:oms) }

      it 'contains the related object' do
        expect(subject.oms).to match_array([related])
      end
    end
  end
end
