# frozen_string_literal: true

RSpec.describe OrganizationMembership, type: :model do
  context 'associations' do
    subject { build :organization_membership }
    let(:roles){ %w(admin write read) }

    it 'has a organization' do
      expect(subject.organization).to be_a(Organization)
    end

    it 'has a user' do
      expect(subject.member).to be_a(User)
    end

    it 'has a role' do
      expect(roles).to include(subject.role)
    end

    it 'has a wrong role' do
      subject.role = 'Bad'
      expect(roles).not_to include(subject.role)
    end
  end
end
