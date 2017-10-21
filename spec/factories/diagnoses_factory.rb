# frozen_string_literal: true

FactoryBot.define do
  factory :diagnosis, class: Debug do
    association :file_version
    association :file_range
    kind { [Error, Warn, Hint, Debug].sample.to_s }
    text { Faker::Lorem.sentence }

    factory :error, class: Error do
      kind { Error.to_s }
    end

    factory :warn, class: Warn do
      kind { Warn.to_s }
    end

    factory :hint, class: Hint do
      kind { Hint.to_s }
    end

    factory :debug, class: Debug do
      kind { Debug.to_s }
    end
  end
end
