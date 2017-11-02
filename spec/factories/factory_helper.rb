# frozen_string_literal: true

require 'faker'
FactoryBot.define do
  to_create(&:save)

  sequence(:filepath) do |n|
    "#{n}_#{Faker::File.file_name(nil, nil, 'txt')}"
  end

  sequence(:username) do |n|
    "#{Faker::Internet.user_name(nil, %w(-))}#{n}".downcase
  end

  sequence(:repository_name) do |n|
    "#{Faker::Commerce.product_name}#{n}"
  end

  sequence(:loc_id_number) do |n|
    n
  end

  sequence(:slug_number) do |n|
    n
  end
end
