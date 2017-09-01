# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LocIdBase, type: :model do
  context 'url' do
    subject { build :loc_id_base }

    context 'validations' do
      context 'loc_id' do
        it 'valid' do
          expect(subject).to be_valid
        end

        it 'invalid' do
          subject.loc_id = subject.loc_id.sub(%r{\A/}, '')
          expect(subject).not_to be_valid
        end
      end
    end
  end
end
