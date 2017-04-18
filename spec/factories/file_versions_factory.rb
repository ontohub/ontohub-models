# frozen_string_literal: true

FactoryGirl.define do
  sequence(:filepath) do |n|
    "#{n}_#{Faker::File.file_name(nil, nil, 'txt')}"
  end

  factory :file_version do
    association :repository
    commit_sha { Faker::Crypto.sha1 }
    path { generate(:filepath) }
    created_at { Time.current }
    updated_at { Time.current }
    url_path_method do
      ->(file_version) { "/file_version/#{file_version.path}" }
    end
  end
end
