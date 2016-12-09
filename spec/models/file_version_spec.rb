# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FileVersion, type: :model do
  context 'columns' do
    it { is_expected.to have_column(:created_at, type: :datetime) }
    it { is_expected.to have_column(:updated_at, type: :datetime) }
    it { is_expected.to have_column(:commit_id, type: :integer) }
    it { is_expected.to have_column(:path, type: :string) }
  end
end
