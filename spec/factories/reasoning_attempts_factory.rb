# frozen_string_literal: true

FactoryGirl.define do
  factory :reasoning_attempt, class: ProofAttempt do
    association :conjecture
    association :reasoner_configuration
    association :used_reasoner, factory: :reasoner
    kind { ProofAttempt.to_s }
    # number { generate(:number) }
    time_taken { rand(120) }
    evaluation_state { 'not_yet_enqueued' }
    reasoning_status { 'OPN' }

    factory :proof_attempt, class: ProofAttempt do
      kind { ProofAttempt.to_s }
    end

    factory :consistency_check_attempt, class: ConsistencyCheckAttempt do
      kind { ConsistencyCheckAttempt.to_s }
    end
  end
end
