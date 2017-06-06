# frozen_string_literal: true

require 'rails_helper'
require 'shared_examples/model_with_url'

RSpec.describe LocIdBase, type: :model do
  context 'url' do
    subject { build :loc_id_base }
    it_behaves_like 'an object that has a URL'
  end
end
