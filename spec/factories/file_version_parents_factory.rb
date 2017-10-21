# frozen_string_literal: true

FactoryBot.define do
  factory :file_version_parent do
    association :last_changed_file_version, factory: :file_version
    queried_sha { Faker::Crypto.sha1 }
  end
end
