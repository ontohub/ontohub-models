# frozen_string_literal: true

FactoryBot.define do
  factory :api_key do
    kind { HetsApiKey.to_s }
    key { Faker::Crypto.sha256 }
    comment { nil }

    factory :hets_api_key, class: HetsApiKey do
      kind { HetsApiKey.to_s }
    end
  end
end
