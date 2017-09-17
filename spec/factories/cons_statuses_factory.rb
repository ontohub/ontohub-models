# frozen_string_literal: true

FactoryGirl.define do
  factory :cons_status do
    required do
      %w(inconsistent string none pcons cons mono def)
    end
    proved do
      %w(inconsistent string none pcons cons mono def)
    end
  end
end
