# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LogicTranslation do
  context 'timestamps' do
    subject { build(:logic_translation) }
    it_behaves_like 'an object with timestamps'
  end

  context 'associations' do
    subject { create(:logic_translation) }
    context 'logic_translation_steps' do
      let!(:unrelated) do
        (1..2).map { create(:logic_translation_step, :with_logic_mapping) }
      end

      let!(:related) do
        steps = (1..2).map do
          create(:logic_translation_step, :with_logic_mapping)
        end
        steps.each do |step|
          subject.add_logic_translation_step(step)
        end
        steps
      end

      it 'has the logic_translation_steps' do
        expect(subject.logic_translation_steps).to match_array(related)
      end
    end
  end

  context 'methods' do
    subject { create(:logic_translation) }
    it_behaves_like 'an object that has a slug set externally'
  end
end
