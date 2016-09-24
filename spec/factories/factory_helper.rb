# frozen_string_literal: true

require 'faker'
FactoryGirl.define do
  to_create { |instance| instance.save }

  sequence :username do |n|
    "#{Faker::Internet.user_name}#{n}"
  end
end
