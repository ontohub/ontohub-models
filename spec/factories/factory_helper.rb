# frozen_string_literal: true

require 'faker'
FactoryGirl.define do
  to_create(&:save)

  sequence :username do |n|
    "#{Faker::Internet.user_name(nil, %w(-))}#{n}".downcase
  end

  sequence :repository_name do |n|
    "#{Faker::Commerce.product_name}#{n}"
  end
end
