# frozen_string_literal: true

FactoryBot.define do
  factory :reasoning_attempt__this_factory_is_abstract, class: ProofAttempt do
    association :action
    association :reasoner_configuration
    association :used_logic_translation, factory: :logic_translation
    association :used_reasoner, factory: :reasoner
    kind { ProofAttempt.to_s }
    time_taken { rand(120) }

    factory :proof_attempt, class: ProofAttempt do
      association :conjecture
      proof_status { 'OPN' }
      kind { ProofAttempt.to_s }
    end

    factory :consistency_check_attempt, class: ConsistencyCheckAttempt do
      association :oms
      consistency_status { 'Open' }
      kind { ConsistencyCheckAttempt.to_s }
    end
  end
end
