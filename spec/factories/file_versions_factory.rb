# frozen_string_literal: true

FactoryGirl.define do
  factory :file_version do
    association :commit
    path { Faker::File.file_name('path/to', Faker::Name.first_name.downcase) }
    created_at { Time.current }
    updated_at { Time.current }
  end
end
