# frozen_string_literal: true

FactoryGirl.define do
  factory :repository_membership do
    association :repository
    association :member, factory: :user
    role { %w(admin write read).sample }
  end
end
