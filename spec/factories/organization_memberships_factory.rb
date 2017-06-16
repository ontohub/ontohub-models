# frozen_string_literal: true

FactoryGirl.define do
  factory :organization_membership do
    association :organization
    association :member, factory: :user
    role { %w(admin write read).sample }
  end
end
