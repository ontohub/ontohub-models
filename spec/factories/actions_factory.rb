# frozen_string_literal: true

FactoryBot.define do
  factory :action do
    evaluation_state { 'not_yet_enqueued' }

    trait :with_message do
      message { Faker::Lorem.sentence }
    end
  end
end
