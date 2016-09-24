FactoryGirl.define do
  factory :user do
    name { generate(:username) }
    created_at { Time.current }
    updated_at { Time.current }
    display_name { Faker::Name.last_name }
    email { Faker::Internet.email(name) }
    password { Faker::Internet.password }
    secret { Faker::Crypto.sha1 }
  end
end
