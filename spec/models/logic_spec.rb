# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Logic do
  context 'timestamps' do
    subject { build(:logic) }
    it_behaves_like 'an object with timestamps'
  end

  context 'associations' do
    subject { create(:logic) }

    context 'language' do
      it_behaves_like('it has a', :language, Language)
      it_behaves_like('being deleted with the association', :language)
    end

    context 'logic_mappings' do
      let!(:as_source) { create(:logic_mapping, source: subject) }
      let!(:as_target) { create(:logic_mapping, target: subject) }
      let!(:unrelated) { create(:logic_mapping) }

      context 'logic_mappings_source' do
        it 'contains the logic_mapping' do
          expect(subject.logic_mappings_source).to match_array([as_source])
        end
      end

      context 'logic_mappings_target' do
        it 'contains the logic_mapping' do
          expect(subject.logic_mappings_target).to match_array([as_target])
        end
      end

      context 'logic_mappings' do
        it 'contains the logic_mapping' do
          expect(subject.logic_mappings).
            to match_array([as_source, as_target])
        end
      end
    end
  end
end
