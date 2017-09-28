# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Axiom do
  context 'superclass' do
    subject { build(:axiom) }
    it_behaves_like 'a loc_id_base'
    it_behaves_like 'a sentence'
  end
end
