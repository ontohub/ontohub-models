# frozen_string_literal: true

FactoryBot.define do
  factory :document, class: Library do
    association :file_version
    kind { Library.to_s }
    display_name { Faker::Lorem.words(2, true).join(' ') }
    name { display_name.parameterize }
    location { Faker::Internet.url }
    version { Faker::App.version }
    loc_id { "#{name}-#{generate(:loc_id_number)}" }

    factory :library, class: Library do
      kind { Library.to_s }
    end

    factory :native_document, class: NativeDocument do
      kind { NativeDocument.to_s }
    end
  end
end
