# frozen_string_literal: true

FactoryGirl.define do
  factory :repository do
    association :owner, factory: :organizational_unit
    name { generate :repository_name }
    url_path_method { ->(repo) { "/repositories/#{repo.to_param}" } }
    description { Faker::Lorem.sentence }
    created_at { Time.current }
    updated_at { Time.current }
    public_access { false }
    content_type { %w(ontology specification model mathematical).sample }
  end
end
