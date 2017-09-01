# frozen_string_literal: true

FactoryGirl.define do
  factory :loc_id_base do
    loc_id { "/#{Faker::Name.unique.title.tr(' ', '/')}" }
  end
end
