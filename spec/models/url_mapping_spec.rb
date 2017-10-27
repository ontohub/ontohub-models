# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UrlMapping do
  context 'associations' do
    subject { create(:url_mapping) }

    context 'repository' do
      it 'is a repository' do
        expect(subject.repository).to be_a(Repository)
      end

      it_behaves_like('being deleted with the association', :repository)
    end
  end

  context 'validations' do
    subject { build(:url_mapping) }

    it 'is valid' do
      expect(subject.valid?).to be(true)
    end

    it 'is invalid without repository' do
      subject.repository = nil
      expect(subject.valid?).to be(false)
    end

    %w(source target).each do |field|
      context field.to_s do
        it "is invalid without #{field}" do
          subject.public_send("#{field}=", nil)
          expect(subject.valid?).to be(false)
        end
      end
    end
  end

  context 'number' do
    subject { build(:url_mapping) }
    it_behaves_like 'having a number', :url_mapping, :repository
  end
end
