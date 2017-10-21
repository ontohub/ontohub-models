# frozen_string_literal: true

FactoryBot.define do
  factory :url_mapping do
    association :repository
    source { Faker::Lorem.word }
    target { Faker::Lorem.word }
  end
end
