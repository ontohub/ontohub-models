# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organization, type: :model do
  context 'compatibility' do
    subject { build :organization }
    it_behaves_like 'an ActiveModel compatible object'
    it_behaves_like 'an ActiveModelSerializer compatible object'
  end

  context 'slug' do
    subject { build :organization }

    it_behaves_like 'an object that has a slug' do
      let(:other_subject) { create :organization, name: subject.name }
    end
  end

  context 'owned repositories' do
    subject { create :organization }

    before do
      5.times { create :repository, owner: subject }
      2.times { create :repository, owner: create(:organization) }
    end

    it 'lists all personal repositories' do
      expect(subject.repositories.count).to be(5)
    end

    it 'destroys the repositories on destroy' do
      id = subject.id
      expect { subject.destroy }.
        to change { Repository.where(owner_id: id).count }.to(0)
    end
  end

  context 'members' do
    subject { create :organization }

    context 'perspective: Organization#members' do
      it 'has none in the beginning' do
        expect(subject.members.count).to eq(0)
      end

      context 'adding members' do
        let(:user) { create :user }
        let(:user2) { create :user }

        before do
          subject.add_member(user)
          subject.add_member(user2)
        end

        it 'has the correct members afterwards' do
          expect(subject.members).to match_array([user, user2])
        end

        context 'deleting the first member again' do
          before { subject.remove_member(user) }

          it 'has only the second member afterwards' do
            expect(subject.members).to match_array([user2])
          end
        end

        context 'deleting all members again' do
          before { subject.remove_all_members }

          it 'has only the second member afterwards' do
            expect(subject.members).to be_empty
          end
        end

        context 'changing role' do
          before { subject.add_member(user, 'write') }

          it 'has changed role' do
            expect(OrganizationMembership.
              find(member: user, organization: subject).role).to match('write')
          end
        end

        it 'deletes all organization memberships on destroy' do
          id = subject.id
          expect { subject.destroy }.
            to change {
              OrganizationMembership.where(organization_id: id).count
            }.to(0)
        end
      end
    end

    context 'perspective: User#organizations' do
      it 'has none in the beginning' do
        expect(subject.members.count).to eq(0)
      end

      context 'adding members' do
        let(:user) { create :user }
        let(:user2) { create :user }

        before do
          user.add_organization(subject)
          user2.add_organization(subject)
        end

        it 'has the correct members afterwards' do
          expect(subject.members).to match_array([user, user2])
        end

        context 'deleting the first member again' do
          before { user.remove_organization(subject) }

          it 'has only the second member afterwards' do
            expect(subject.members).to match_array([user2])
          end
        end
      end
    end
  end
end
