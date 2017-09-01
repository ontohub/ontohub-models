# frozen_string_literal: true

FactoryGirl.define do
  sequence(:filepath) do |n|
    "#{n}_#{Faker::File.file_name(nil, nil, 'txt')}"
  end

  factory :file_version do
    association :repository
    commit_sha { Faker::Crypto.sha1 }
    path { generate(:filepath) }
  end
end
