# frozen_string_literal: true

FactoryGirl.define do
  factory :language do
    name { Faker::Lorem.words(4, true).join(' ') }
    slug { name.parameterize }
    description { Faker::Lorem.sentences(2).join(' ') }
    standardization_status { Faker::Lorem.word }
    defined_by { 'registry' }
  end
end
