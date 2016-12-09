# frozen_string_literal: true

FactoryGirl.define do
  factory :commit do
    association :repository
    association :author, factory: :user
    association :editor, factory: :user
    created_at { Time.current }
    updated_at { Time.current }
    authored_at { Time.current }
    edited_at { Time.current }
    author_name { Faker::Name }
    editor_name { Faker::Name }
    shasum { Faker::Lorem.characters(40) }
  end
end
