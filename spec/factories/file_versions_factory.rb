# frozen_string_literal: true

FactoryBot.define do
  factory :file_version do
    association :repository
    commit_sha { Faker::Crypto.sha1 }
    path { generate(:filepath) }
    evaluation_state { 'not_yet_enqueued' }

    after(:create) do |file_version|
      FileVersionParent.create(queried_sha: file_version.commit_sha,
                               last_changed_file_version: file_version)
    end
  end
end
