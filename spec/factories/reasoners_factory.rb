# frozen_string_literal: true

FactoryBot.define do
  factory :reasoner, class: Prover do
    display_name { Faker::Lorem.words(4).join(' ') }
    slug { "#{display_name.parameterize}-#{generate(:slug_number)}" }
    kind { Prover.to_s }

    factory :prover, class: Prover do
      kind { Prover.to_s }
    end

    factory :consistency_checker, class: ConsistencyChecker do
      kind { ConsistencyChecker.to_s }
    end
  end
end
