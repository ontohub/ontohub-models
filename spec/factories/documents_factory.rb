# frozen_string_literal: true

FactoryGirl.define do
  factory :document do
    association :file_version
    kind { [Library, NativeDocument].map(&:to_s).sample }
    display_name { Faker::Lorem.words(4, true).join(' ') }
    name { display_name.parameterize }
    location { Faker::Internet.url }
    version { Faker::App.version }
    loc_id { Faker::Lorem.words(4, true).join(' ') }

    factory :library, class: Library do
      kind { Library.to_s }
    end

    factory :native_document, class: NativeDocument do
      kind { NativeDocument.to_s }
    end
  end
end
