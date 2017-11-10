# frozen_string_literal: true

FactoryBot.define do
  factory :api_key do
    key { Faker::Crypto.sha256 }
    comment { nil }
  end
end
