# frozen_string_literal: true

FactoryGirl.define do
  factory :url_mapping do
    association :repository
    source { Faker::Lorem.word }
    target { Faker::Lorem.word }
  end
end
