# frozen_string_literal: true

FactoryBot.define do
  factory :cons_status do
    required do
      %w(inconsistent string none pcons cons mono def).sample
    end
    proved do
      %w(inconsistent string none pcons cons mono def).sample
    end
  end
end
