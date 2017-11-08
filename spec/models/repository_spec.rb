# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository, type: :model do
  context 'validations' do
    subject { build :repository, name: Faker::Lorem.words(2).join(' ') }
    context 'name' do
      it 'is invalid without name' do
        subject.name = nil
        expect(subject.valid?).to be(false)
      end

      it 'is invalid with a name which is to short' do
        subject.name = 'fo'
        expect(subject.valid?).to be(false)
      end
    end

    context 'owner' do
      it 'is invalid if the owner is nil' do
        subject.owner = nil
        expect(subject.valid?).to be(false)
      end
    end

    context 'access' do
      it 'public access is nil' do
        subject.public_access = nil
        expect(subject.valid?).to be(false)
      end
    end

    context 'content' do
      %w(ontology model specification mathematical).each do |content_type|
        it "is valid with #{content_type} content type" do
          subject.content_type = content_type
          expect(subject.valid?).to be(true)
        end
      end

      it 'has a value that is not allowed' do
        subject.content_type = 'not_allowed'
        expect(subject.valid?).to be(false)
      end
    end

    context 'mirror or fork' do
      shared examples 'subject validation' do
        expect(subject.valid?).to be(expectation_subject_valid)
      end
      context 'remote type is valid' do
        context 'remote adress is valid' do
          it_behaves_like 'subject validation' {}
        end

        context 'remote type is not valid' do

        end
      end

      context 'remote type is not valid' do
        it_behaves_like 'subject validation'
        context 'remote adress is not valid' do

        end
      end
    end
  end

  context 'compatibility' do
    subject { build :repository, name: Faker::Lorem.words(2).join(' ') }
    it_behaves_like 'an ActiveModel compatible object'
    it_behaves_like 'an ActiveModelSerializer compatible object'
  end

  context 'slug' do
    subject { build :repository, name: Faker::Lorem.words(2).join(' ') }

    it_behaves_like 'an object that has a slug', ',' do
      let(:other_subject) { create :repository, owner: subject.owner }
    end

    it "merges the owner's slug with the own name" do
      subject.save
      expect(subject.slug).
        to eq("#{subject.owner.slug}/"\
              "#{Slug.sluggify(subject.name)}")
    end
  end

  context 'timestamps' do
    subject { build(:repository) }
    it_behaves_like 'an object with timestamps'
  end

  context 'file_versions' do
    subject { create(:repository, name: Faker::Lorem.words(2).join(' ')) }

    before do
      5.times do
        create(:file_version, repository: subject)
      end
    end

    it 'destroys the file_versions on destroy' do
      id = subject.id
      expect { subject.destroy }.
        to change { FileVersion.where(repository_id: id).count }.to(0)
    end
  end

  context 'membership' do
    subject { create(:repository, name: Faker::Lorem.words(2).join(' ')) }
    let(:member) { create :user }

    it 'adds new member with read role' do
      subject.add_member(member)
      expect(RepositoryMembership.
        find(member: member, repository: subject).role).to eq('read')
    end

    context 'existent member' do
      before { subject.add_member(member) }

      it 'changes role of existent member' do
        subject.add_member(member, 'write')
        expect(RepositoryMembership.find(member: member, repository: subject).
          role).to match('write')
      end

      it 'removes member' do
        subject.remove_member(member)
        expect(RepositoryMembership.find(member: member, repository: subject)).
          to be_falsy
      end
    end
  end

  context 'associations' do
    subject { create(:repository) }

    context 'owner' do
      it_behaves_like('it has a', :owner, OrganizationalUnit)
      it_behaves_like('restricting the deletion of the association', :owner)
    end

    context 'url_mappings' do
      let!(:unrelated) { create(:url_mapping) }
      let!(:url_mappings) { create_list(:url_mapping, 3, repository: subject) }

      it 'has the url_mappings' do
        expect(subject.url_mappings).to eq(url_mappings)
      end
    end
  end
end
