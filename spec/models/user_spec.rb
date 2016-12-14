# frozen_string_literal: true

require 'rails_helper'
require 'devise'

require 'shared_examples/model_with_url'
require 'shared_examples/slug'

RSpec.describe User, type: :model do
  context 'columns' do
    it { is_expected.to have_column(:real_name, type: :string) }
    it { is_expected.to have_column(:email, type: :string) }
    it { is_expected.to have_column(:encrypted_password, type: :string) }
  end

  context 'url' do
    subject { build :user }
    it_behaves_like 'an object that has a URL'
  end

  context 'slug' do
    subject { build :user }

    it_behaves_like 'an object that has a slug'
  end

  context 'password' do
    subject { create :user, password: 'foobar' }

    it 'saved the password encrypted' do
      expect(subject.encrypted_password.length).to be(60)
      expect(subject.encrypted_password).to match(/^\$2a\$/)
    end

    it 'validates the password correctly' do
      expect(subject.valid_password?('foobar')).to be true
      expect(subject.valid_password?('barfoo')).to be false
    end

    it 'updates the encrypted password when the password is updated' do
      old_pw = subject.encrypted_password
      subject.password = 'barfoo'
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
