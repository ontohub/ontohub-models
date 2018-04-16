# frozen_string_literal: true

FactoryBot.define do
  factory :sentence, class: Axiom do
    association :oms
    association :file_range
    kind { Axiom.to_s }
    name { Faker::Lorem.words(2, true).join(' ') }
    text { Faker::Lorem.sentence }
    loc_id { "#{name}-#{generate(:loc_id_number)}" }

    after(:build) do |sentence|
      sentence.file_version = sentence.oms.file_version
    end

    factory :axiom, class: Axiom do
      kind { Axiom.to_s }
    end

    factory :conjecture, class: OpenConjecture do
      association :action
      kind { OpenConjecture.to_s }
      proof_status { 'OPN' }

      factory :open_conjecture, class: OpenConjecture do
        kind { OpenConjecture.to_s }
      end

      factory :counter_theorem, class: CounterTheorem do
        kind { CounterTheorem.to_s }
      end

      factory :theorem, class: Theorem do
        kind { Theorem.to_s }
      end
    end

    trait :with_original_sentence do
      association :original_sentence
    end
  end
end
