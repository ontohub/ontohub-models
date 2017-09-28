# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LanguageMapping do
  context 'timestamps' do
    subject { build(:language_mapping) }
    it_behaves_like 'an object with timestamps'
  end

  context 'associations' do
    subject { create(:language_mapping) }

    context 'source' do
      it 'is a language' do
        expect(subject.source).to be_a(Language)
      end

      it_behaves_like('being deleted with the association', :source)
    end

    context 'target' do
      it 'is a language' do
        expect(subject.target).to be_a(Language)
      end

      it_behaves_like('being deleted with the association', :target)
    end
  end
end
