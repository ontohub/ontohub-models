# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Commit, type: :model do
  context 'columns' do
    it { is_expected.to have_column(:created_at, type: :datetime) }
    it { is_expected.to have_column(:updated_at, type: :datetime) }
    it { is_expected.to have_column(:repository_id, type: :integer) }
    it { is_expected.to have_column(:author_id, type: :integer) }
    it { is_expected.to have_column(:editor_id, type: :integer) }
    it { is_expected.to have_column(:author_name, type: :string) }
    it { is_expected.to have_column(:editor_name, type: :string) }
    it { is_expected.to have_column(:authored_at, type: :datetime) }
    it { is_expected.to have_column(:edited_at, type: :datetime) }
    it { is_expected.to have_column(:shasum, type: :string) }
  end
end