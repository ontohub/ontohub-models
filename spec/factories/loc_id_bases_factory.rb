# frozen_string_literal: true

FactoryBot.define do
  factory :loc_id_base, class: NativeDocument do
    association :file_version
    loc_id do
      "/#{Faker::Name.unique.title.tr(' ', '/')}-#{generate(:loc_id_number)}"
    end
  end
end
