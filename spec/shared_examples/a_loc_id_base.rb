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

  context 'dataset_module' do
    context 'where_commit_sha' do
      let!(:new_file_version) { create(:file_version) }

      before do
        subject.save
        FileVersionParent.
          create(last_changed_file_version: subject.file_version,
                 queried_sha: new_file_version.commit_sha)
      end

      it 'finds the model at the newer version that does not change its file' do
        expect(subject.class.
                 where_commit_sha(commit_sha: new_file_version.commit_sha,
                                  loc_id: subject.loc_id).all).
          to match_array([subject])
      end

      it 'finds the model from LocIdBase at the newer version '\
           'that does not change its file' do
        expect(LocIdBase.
                 where_commit_sha(commit_sha: new_file_version.commit_sha,
                                  loc_id: subject.loc_id).all).
          to match_array([subject])
      end
    end
  end
end
