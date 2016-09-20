# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespace, type: :model do
  context 'columns' do
    it { is_expected.to have_column(:created_at, type: :datetime) }
    it { is_expected.to have_column(:updated_at, type: :datetime) }
    it { is_expected.to have_column(:organizational_unit_id, type: :integer) }
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
