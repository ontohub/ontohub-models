# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'a loc_id_base' do
  context 'associations' do
    before { subject.save }

    context 'file_version' do
      it_behaves_like('it has a', :file_version, FileVersion)
      it_behaves_like('being deleted with the association', :file_version)
    end
  end

  context 'validations' do
    context 'loc_id' do
      it 'valid' do
        expect(subject).to be_valid
      end

      it 'invalid' do
        subject.loc_id = nil
        expect(subject).not_to be_valid
      end
    end
  end
end
