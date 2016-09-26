# frozen_string_literal: true

require 'faker'
FactoryGirl.define do
  to_create { |instance| instance.save }

  sequence :username do |n|
    "#{Faker::Internet.user_name}#{n}"
  end

  sequence :org_unit_name do |n|
    "#{Faker::Name.last_name}#{n}"
  end

  sequence :repository_name do |n|
    "#{Faker::Commerce.product_name}#{n}"
  end
end
