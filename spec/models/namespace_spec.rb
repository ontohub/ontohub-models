# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespace, type: :model do
  context 'columns' do
    it { is_expected.to have_column(:created_at, type: :datetime) }
    it { is_expected.to have_column(:updated_at, type: :datetime) }
    it { is_expected.to have_column(:organizational_unit_id, type: :integer) }
  end

  context 'to_param' do
    subject { create :namespace }
    it 'is the slug' do
      expect(subject.to_param).to eq(subject.slug)
    end
  end

  context 'find' do
    subject { create :namespace }
    context 'by id' do
      it 'can be found' do
        expect(subject.class.find(id: subject.id)).to eq(subject.reload)
      end
    end

    context 'by slug' do
      it 'can be found' do
        expect(subject.class.find(slug: subject.slug)).to eq(subject.reload)
      end

      it 'behaves correctly if the slug is nil' do
        expect(subject.class.find(slug: nil)).to be(nil)
      end
    end
  end

  context 'slug' do
    subject { create :namespace }
    it "is equal to the organizational unit's slug" do
      expect(subject.slug).to eq(subject.organizational_unit.slug)
    end
  end

  context 'deletion' do
    subject { create :namespace }

    before do
      2.times { create :repository, namespace: subject }
      subject.destroy
    end

    it 'removes the repositories' do
      expect(Repository.all).to be_empty
    end
  end
end
