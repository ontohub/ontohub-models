# frozen_string_literal: true

FactoryGirl.define do
  factory :file_version do
    association :repository
    commit_sha { Faker::Crypto.sha1 }
    path { generate(:filepath) }
  end
end
