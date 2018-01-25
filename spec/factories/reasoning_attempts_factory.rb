# frozen_string_literal: true

FactoryBot.define do
  factory :reasoning_attempt__this_factory_is_abstract, class: ProofAttempt do
    association :action
    association :reasoner_configuration
    association :used_logic_mapping, factory: :logic_mapping
    association :used_reasoner, factory: :reasoner
    kind { ProofAttempt.to_s }
    time_taken { rand(120) }
    reasoning_status { 'OPN' }

    factory :proof_attempt, class: ProofAttempt do
      association :conjecture
      kind { ProofAttempt.to_s }
    end

    factory :consistency_check_attempt, class: ConsistencyCheckAttempt do
      association :oms
      kind { ConsistencyCheckAttempt.to_s }
    end
  end
end
