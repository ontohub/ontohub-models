# frozen_string_literal: true

FactoryGirl.define do
  factory :commit do
    association :repository
    association :author, factory: :user
    association :editor, factory: :user
    association :pusher, factory: :user
    created_at { Time.current }
    updated_at { Time.current }
    authored_at { Time.current }
    edited_at { Time.current }
    author_name { author&.name }
    editor_name { editor&.name }
    shasum { Faker::Lorem.characters(40) }
    url_path_method { ->(commit) { "/commit/#{commit.to_param}" } }
  end
end
