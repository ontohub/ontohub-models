# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Serialization do
  context 'timestamps' do
    subject { build(:serialization) }
    it_behaves_like 'an object with timestamps'
  end

  context 'associations' do
    subject { create(:serialization) }

    context 'language' do
      it_behaves_like('it has a', :language, Language)
      it_behaves_like('being deleted with the association', :language)
    end
  end
end
