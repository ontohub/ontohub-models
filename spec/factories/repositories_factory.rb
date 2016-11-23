# frozen_string_literal: true

FactoryGirl.define do
  factory :repository do
    association :namespace
    name { generate :repository_name }
    url_path { "/repositories/#{Slug.sluggify(name)}" }
    description { Faker::Lorem.sentence }
    created_at { Time.current }
    updated_at { Time.current }
    public_access { false }
    content_type { 'ontology' }
  end
end
