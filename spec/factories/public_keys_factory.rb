# frozen_string_literal: true

FactoryGirl.define do
  factory :public_key do
    association :user, factory: :user
    name { Faker::App.unique.name }
    key { 'ssh-rsa ' + Base64.strict_encode64(Faker::Crypto.sha256) }
  end
end
