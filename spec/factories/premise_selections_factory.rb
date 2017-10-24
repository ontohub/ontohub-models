# frozen_string_literal: true

FactoryBot.define do
  factory :premise_selection, class: ManualPremiseSelection do
    association :reasoner_configuration

    factory :manual_premise_selection, class: ManualPremiseSelection do
      kind { ManualPremiseSelection.to_s }
    end

    factory :sine_premise_selection, class: SinePremiseSelection do
      kind { SinePremiseSelection.to_s }
      depth_limit { rand(5) }
      tolerance { 1 + rand }
      axiom_number_limit { rand(100) }
    end
  end
end
