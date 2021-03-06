# frozen_string_literal: true

FactoryBot.define do
  factory :language do
    name { Faker::Lorem.words(4, true).join(' ') }
    slug { "#{name.parameterize}-#{generate(:slug_number)}" }
    description { Faker::Lorem.sentences(2).join(' ') }
    standardization_status { Faker::Lorem.word }
    defined_by { 'registry' }
  end
end
