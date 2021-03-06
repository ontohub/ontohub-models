
# frozen_string_literal: true

FactoryBot.define do
  factory :symbol, class: OMSSymbol do
    association :oms, factory: :oms
    association :file_range
    symbol_kind { %w(Op Pred Proposition Class Individual Name).sample }
    full_name { Faker::Lorem.words(2, true).join(' ') }
    name { full_name.parameterize }
    loc_id { "#{name}-#{generate(:loc_id_number)}" }

    after(:build) do |symbol|
      symbol.file_version = symbol.oms.file_version
    end
  end
end
