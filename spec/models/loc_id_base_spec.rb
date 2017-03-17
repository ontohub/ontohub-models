# frozen_string_literal: true

require 'rails_helper'
require 'shared_examples/model_with_url'

RSpec.describe LocIdBase, type: :model do
  context 'columns' do
    it { is_expected.to have_column(:created_at, type: :datetime) }
    it { is_expected.to have_column(:updated_at, type: :datetime) }
  end

  context 'url' do
    subject { build :loc_id_base }
    it_behaves_like 'an object that has a URL'
  end
end
