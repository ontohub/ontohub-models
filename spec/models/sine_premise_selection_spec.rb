# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SinePremiseSelection do
  context 'superclass' do
    subject { build(:sine_premise_selection) }
    it_behaves_like 'a premise_selection'
  end

  context 'associations' do
    subject { create(:sine_premise_selection) }

    context 'sine_symbol_commonness' do
      let!(:unrelated) do
        (1..2).map { create(:sine_symbol_commonness) }
      end

      let!(:related) do
        (1..2).map do
          create(:sine_symbol_commonness, sine_premise_selection: subject)
        end
      end

      it 'has the sentences' do
        expect(subject.sine_symbol_commonnesses).to match_array(related)
      end
    end

    context 'sine_symbol_premise_triggers' do
      let!(:unrelated) do
        (1..2).map { create(:sine_symbol_premise_trigger) }
      end

      let!(:related) do
        (1..2).map do
          create(:sine_symbol_premise_trigger, sine_premise_selection: subject)
        end
      end

      it 'has the sentences' do
        expect(subject.sine_symbol_premise_triggers).to match_array(related)
      end
    end
  end
end
