# frozen_string_literal: true

FactoryBot.define do
  factory :reasoner do
    display_name { Faker::Lorem.words(4).join(' ') }
    slug { "#{display_name.parameterize}-#{generate(:slug_number)}" }
  end
end
