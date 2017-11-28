# frozen_string_literal: true

FactoryBot.define do
  factory :mapping do
    association :source, factory: :oms
    association :target, factory: :oms
    association :signature_morphism
    association :conservativity_status
    transient do
      freeness_parameter_oms { nil }
      freeness_parameter_language { nil }
    end
    display_name { rand }
    name { generate(:loc_id_number) }
    loc_id { name }
    origin do
      %w(see_target see_source test dg_link_verif dg_implies_link
         dg_link_extension dg_link_translation dg_link_closed_lenv
         dg_link_imports dg_link_intersect dg_link_morph dg_link_inst
         dg_link_inst_arg dg_link_view dg_link_align dg_link_fit_view
         dg_link_fit_view_imp dg_link_proof dg_link_flattening_union
         dg_link_flattening_rename dg_link_refinement).sample
    end

    type do
      %w(local_def local_thm_open local_thm_proved
         global_def global_thm_open global_thm_proved
         hiding_def
         free_def cofree_def np_free_def minimize_def
         hiding_open hiding_proved
         free_open cofree_open
         np_free_open minimize_open
         free_proved cofree_proved
         np_free_proved minimize_proved).sample
    end

    pending { Faker::Boolean.boolean }

    after(:build) do |mapping, evaluator|
      mapping.file_version = mapping.source.file_version

      if evaluator.freeness_parameter_oms
        mapping.freeness_parameter_oms = evaluator.freeness_parameter_oms
      end
      if evaluator.freeness_parameter_language
        mapping.freeness_parameter_language =
          evaluator.freeness_parameter_language
      end
    end
  end
end
