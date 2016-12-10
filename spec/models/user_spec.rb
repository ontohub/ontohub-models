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
    subject { build :repository }
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

  context 'personal repositories' do
    subject { create :user }

    before do
      5.times { create :repository, owner: subject }
      2.times { create :repository, owner: create(:user) }
    end

    it 'lists all personal repositories' do
      expect(subject.repositories.count).to be(5)
    end
  end
end
