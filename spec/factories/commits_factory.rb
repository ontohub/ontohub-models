# frozen_string_literal: true

FactoryGirl.define do
  factory :commit do
    association :repository
    association :author, factory: :user
    association :committer, factory: :user
    association :pusher, factory: :user
    created_at { Time.current }
    updated_at { Time.current }
    authored_at { Time.current }
    committed_at { Time.current }
    author_name { author&.name }
    committer_name { committer&.name }
    shasum { Faker::Lorem.characters(40) }
    url_path_method { ->(commit) { "/commit/#{commit.to_param}" } }
  end
end
