# frozen_string_literal: true

FactoryBot.define do
  factory :oms, class: OMS do
    association :action
    association :document
    association :language
    association :logic
    association :serialization
    association :signature
    association :conservativity_status
    association :name_file_range, factory: :file_range

    consistency_status { 'Open' }
    display_name { Faker::Lorem.words(rand(2..4)).join(' ') }
    name { Faker::Internet.url('example.com', display_name) }
    name_extension { 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('').sample }
    name_extension_index { rand(10) }
    description { Faker::Lorem.sentence }
    origin do
      %w(dg_empty dg_basic dg_basic_spec dg_extension dg_logic_coercion
         dg_translation dg_union dg_intersect dg_extract dg_restriction
         dg_reveal_translation free cofree np_free minimize dg_local dg_closed
         dg_logic_qual dg_data dg_formal_params dg_imports dg_inst dg_fit_spec
         dg_fit_view dg_proof dg_normal_form dg_integrated_scc dg_flattening
         dg_alignment dg_test).sample
    end
    label_has_hiding { Faker::Boolean.boolean }
    label_has_free { Faker::Boolean.boolean }
    loc_id { "#{display_name}-#{generate(:loc_id_number)}" }

    after(:build) do |oms|
      oms.file_version = oms.document.file_version
    end

    trait :with_normal_form do
      association :normal_form, factory: :oms
      after(:create) do |oms|
        oms.normal_form.save
        oms.normal_form_signature_morphism =
          create(:signature_morphism,
                 source: oms.signature,
                 target: oms.normal_form.signature)
        oms.save
      end
    end

    trait :with_free_normal_form do
      association :free_normal_form, factory: :oms
      after(:create) do |oms|
        oms.free_normal_form.save
        oms.free_normal_form_signature_morphism =
          create(:signature_morphism,
                 source: oms.signature,
                 target: oms.free_normal_form.signature)
        oms.save
      end
    end
  end
end
