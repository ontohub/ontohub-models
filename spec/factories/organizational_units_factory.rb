# frozen_string_literal: true

FactoryGirl.define do
  factory :organizational_unit do
    name { generate :username }
    url_path_method do
      ->(org_unit) { "/organizational_units/#{org_unit.to_param}" }
    end
    created_at { Time.current }
    updated_at { Time.current }
  end
end
