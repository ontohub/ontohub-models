# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FileVersionParent, type: :model do
  context 'associations' do
    subject { create(:file_version_parent) }

    context 'last_changed_file_version' do
      it_behaves_like('it has a', :last_changed_file_version, FileVersion)
      it_behaves_like('being deleted with the association',
                      :last_changed_file_version,
                      %i(last_changed_file_version_id queried_sha))
    end
  end
end
