# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CounterTheorem do
  context 'superclass' do
    subject { build(:counter_theorem) }
    it_behaves_like 'a loc_id_base'
    it_behaves_like 'a conjecture'
  end
end
