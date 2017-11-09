# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OpenConjecture do
  context 'superclass' do
    subject { build(:open_conjecture) }
    it_behaves_like 'a loc_id_base'
    it_behaves_like 'a conjecture'
  end
end
