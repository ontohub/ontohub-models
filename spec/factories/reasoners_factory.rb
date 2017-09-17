# frozen_string_literal: true

FactoryGirl.define do
  factory :reasoner do
    display_name { Faker::Lorem.words(4).join(' ') }
    slug { display_name.parameterize }
  end
end
