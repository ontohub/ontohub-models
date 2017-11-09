# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Language do
  context 'timestamps' do
    subject { build(:language) }
    it_behaves_like 'an object with timestamps'
  end

  context 'associations' do
    subject { create(:language) }

    context 'language_mappings' do
      let!(:as_source) { create(:language_mapping, source: subject) }
      let!(:as_target) { create(:language_mapping, target: subject) }
      let!(:unrelated) { create(:language_mapping) }

      context 'language_mappings_source' do
        it 'contains the language_mapping' do
          expect(subject.language_mappings_by_source).
            to match_array([as_source])
        end
      end

      context 'language_mappings_target' do
        it 'contains the language_mapping' do
          expect(subject.language_mappings_by_target).
            to match_array([as_target])
        end
      end

      context 'language_mappings' do
        it 'contains the language_mapping' do
          expect(subject.language_mappings).
            to match_array([as_source, as_target])
        end
      end
    end
  end

  context 'methods' do
    subject { create(:language) }
    it_behaves_like 'an object that has a slug set externally'
  end
end
