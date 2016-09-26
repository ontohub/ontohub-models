# frozen_string_literal: true

FactoryGirl.define do
  factory :organizational_unit do
    name { generate :org_unit_name }
    created_at { Time.current }
    updated_at { Time.current }
  end
end
