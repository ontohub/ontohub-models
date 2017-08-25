# frozen_string_literal: true

FactoryGirl.define do
  factory :public_key do
    association :user, factory: :user
    name { Faker::Cat.unique.name }
    key { Faker::Crypto.sha256 }
  end
end
