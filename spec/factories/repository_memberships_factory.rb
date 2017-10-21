# frozen_string_literal: true

FactoryBot.define do
  factory :repository_membership do
    association :repository
    association :member, factory: :user
    role { %w(admin write read).sample }
  end
end
