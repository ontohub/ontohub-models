# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConsistencyCheckAttempt, type: :model do
  subject { build(:consistency_check_attempt) }
  it_behaves_like 'having a number', :consistency_check_attempt, :oms

  context 'superclass' do
    subject { create(:consistency_check_attempt) }
    it_behaves_like 'a reasoning_attempt'

    context 'oms' do
      it_behaves_like('it has a', :oms, OMS)
      it_behaves_like('being deleted with the association', :oms)
    end
  end
end
