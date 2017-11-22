# frozen_string_literal: true

FactoryBot.define do
  factory :repository do
    association :owner, factory: :user
    name { generate :repository_name }
    description { Faker::Lorem.sentence }
    public_access { false }
    content_type { %w(ontology specification model mathematical).sample }
    remote_address { nil }
    remote_type { nil }
    trait :fork do
      remote_address { "#{Faker::Internet.url}.git" }
      remote_type { 'fork' }
    end
    trait :mirror do
      remote_address { "#{Faker::Internet.url}.git" }
      remote_type { 'mirror' }
    end
  end
end
