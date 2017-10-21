# frozen_string_literal: true

FactoryBot.define do
  factory :sentence, class: Axiom do
    association :oms
    association :file_range
    kind { [Axiom, OpenConjecture, CounterTheorem, Theorem].sample.to_s }
    name { Faker::Lorem.word }
    text { Faker::Lorem.sentence }
    loc_id { name }

    after(:build) do |sentence|
      sentence.file_version = sentence.oms.file_version
    end

    factory :axiom, class: Axiom do
      kind { Axiom.to_s }
    end

    factory :conjecture, class: Conjecture do
      kind { [OpenConjecture, CounterTheorem, Theorem].map(&:to_s).sample }
      evaluation_state { 'not_yet_enqueued' }
      reasoning_status { 'OPN' }

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
  end
end
