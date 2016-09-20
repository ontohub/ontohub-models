# frozen_string_literal: true

FactoryGirl.define do
  factory :namespace do
    initialize_with { create(:organizational_unit).namespace }
  end
end
