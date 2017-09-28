# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'a diagnosis' do
  context 'associations' do
    before { subject.save }

    context 'file_version' do
      it_behaves_like('it has a', :file_version, FileVersion)
      it_behaves_like('being deleted with the association', :file_version)
    end

    it_behaves_like 'having a file_range'
  end

  it_behaves_like 'having a number', :diagnosis, :file_version
end
