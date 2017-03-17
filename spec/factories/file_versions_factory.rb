# frozen_string_literal: true

FactoryGirl.define do
  factory :file_version do
    commit_sha { Faker::Lorem.characters(40) }
    path { Faker::File.file_name('path/to', Faker::Name.first_name.downcase) }
    created_at { Time.current }
    updated_at { Time.current }
    url_path_method do
      ->(file_version) { "/file_version/#{file_version.to_param}" }
    end
  end
end
