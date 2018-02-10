# frozen_string_literal: true

FactoryBot.define do
  factory :public_key do
    association :user, factory: :user
    name { Faker::Lorem.unique.word }
    key { 'ssh-rsa ' + Base64.strict_encode64(Faker::Crypto.sha256) }
  end
end
