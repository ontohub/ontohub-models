FactoryGirl.define do
  factory :repository do
    name Faker::Name.last_name
    description Faker::Lorem.sentence
    created_at Time.now
    updated_at Time.now
  end
end
