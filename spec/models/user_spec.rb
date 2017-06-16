# frozen_string_literal: true

require 'rails_helper'

require 'shared_examples/active_model'
require 'shared_examples/active_model_serializer'
require 'shared_examples/model_with_url'
require 'shared_examples/slug'

RSpec.describe User, type: :model do
  context 'warden' do
    subject { create :user }
    it 'find_for_database_authentication' do
      expect(User.find_for_database_authentication(name: subject.to_param)).
        to eq(subject)
    end
  end

  context 'compatibility' do
    subject { build :user }
    it_behaves_like 'an ActiveModel compatible object'
    it_behaves_like 'an ActiveModelSerializer compatible object with devise'
  end

  context 'url' do
    subject { build :user }
    it_behaves_like 'an object that has a URL'
  end

  context 'slug' do
    subject { build :user }

    it_behaves_like 'an object that has a slug', ',' do
      let(:other_subject) { create :user, name: subject.name }
    end
  end

  context 'password' do
    let(:password) { 'foobarfoobarbaz' }
    subject { create :user, password: password }

    it 'saved the password encrypted' do
      expect(subject.encrypted_password.length).to be(60)
      expect(subject.encrypted_password).to match(/^\$2a\$/)
    end

    it 'validates the password correctly' do
      expect(subject.valid_password?(password)).to be true
      expect(subject.valid_password?("#{password}-bad")).to be false
    end

    it 'updates the encrypted password when the password is updated' do
      old_pw = subject.encrypted_password
      subject.password = 'bazbarfoobarfoo'
      expect(subject.encrypted_password).not_to equal(old_pw)
    end
  end

  context 'owned repositories' do
    subject { create :user }

    before do
      5.times { create :repository, owner: subject }
      2.times { create :repository, owner: create(:user) }
    end

    it 'lists all personal repositories' do
      expect(subject.repositories.count).to eq(5)
    end
  end

  context 'accessible repositories' do
    subject { create :user }
    let(:organization1) { create :organization }
    let(:organization2) { create :organization }
    let!(:repositories) do
      [create(:repository, owner: subject),
       create(:repository, owner: organization1),
       create(:repository, owner: organization2)]
    end

    before do
      organization1.add_member(subject)
      organization2.add_member(subject)

      other_user = create(:user)
      other_organization = create(:organization)
      other_organization.add_member(other_user)
      create(:repository, owner: other_user)
      create(:repository, owner: other_organization)
    end

    it 'lists the correct repositories' do
      expect(subject.accessible_repositories).to match_array(repositories)
    end
  end

  context 'roles' do
    subject { create :user }
    let(:roles) { %w(admin user) }

    it 'has a role' do
      expect(roles).to include(subject.role)
    end

    it 'has a wrong role' do
      subject.role = 'Bad'
      expect(roles).not_to include(subject.role)
    end
  end

  context 'associations' do
    subject { create :user }
    let!(:organization1) { create :organization }
    let!(:organization2) { create :organization }
    let!(:user2) { create :user }
    let!(:repository1) { create(:repository, owner: subject) }
    let!(:repository2) { create(:repository, owner: organization1) }
    let!(:repository3) { create(:repository, owner: organization2) }
    let!(:repository4) { create(:repository, owner: user2) }
    let!(:repository5) { create(:repository, owner: organization2) }

    before do
      subject.add_organization(organization1)
      repository2.add_member(subject)
      repository3.add_member(subject)
    end

    context 'repositories' do
      it 'return correct repositories' do
        expect(subject.repositories).to match_array([repository1])
      end
    end

    context 'repositories_by_organizations' do
      it 'returns correct repositories' do
        expect(subject.repositories_by_organizations).
          to match_array([repository2])
      end
    end

    context 'repositories_by_membership' do
      it 'returns correct repositories' do
        expect(subject.repositories_by_membership).
          to match_array([repository2, repository3])
      end
    end

    context 'foreign_repositories' do
      it 'returns correct repositories' do
        expect(subject.foreign_repositories).
          to match_array([repository2, repository3])
      end
    end

    context 'accessbile_repositories' do
      it 'returns correct repositories' do
        expect(subject.accessible_repositories).
          to match_array([repository1, repository2, repository3])
      end
    end
  end

  context 'organizations' do
    subject { create :user }

    context 'perspective: Organization#members' do
      context 'adding the user to another organization' do
        let(:organization) { create :organization }
        let(:organization2) { create :organization }

        it 'the organization has no members yet' do
          expect(organization.members).to be_empty
        end

        context 'adding members' do
          before do
            organization.add_member(subject)
            organization2.add_member(subject)
          end

          it 'has the correct organizations afterwards' do
            expect(subject.organizations).
              to match_array([organization, organization2])
          end

          context 'deleting it from the first organization again' do
            before { organization.remove_member(subject) }

            it 'has only the second organization afterwards' do
              expect(subject.organizations).to match_array([organization2])
            end
          end
        end
      end
    end

    context 'perspective: User#organizations' do
      it 'has none in the beginning' do
        expect(subject.organizations.count).to eq(0)
      end

      context 'adding the user to organizations' do
        let(:organization) { create :organization }
        let(:organization2) { create :organization }
        before do
          subject.add_organization(organization)
          subject.add_organization(organization2)
        end

        it 'has the correct organizations afterwards' do
          expect(subject.organizations).
            to match_array([organization, organization2])
        end

        context 'deleting it from the first organization again' do
          before { subject.remove_organization(organization) }

          it 'has only the second organization afterwards' do
            expect(subject.organizations).to match_array([organization2])
          end
        end

        context 'deleting it from all its organizations again' do
          before { subject.remove_all_organizations }

          it 'has only the second organization afterwards' do
            expect(subject.organizations).to be_empty
          end
        end
      end
    end
  end
end
