# frozen_string_literal: true

FactoryGirl.define do
  factory :mapping do
    association :source, factory: :oms
    association :target, factory: :oms
    association :signature_morphism
    association :cons_status
    association :freeness_parameter_oms, factory: :oms
    association :freeness_parameter_language, factory: :language
    display_name { rand }
    name { rand }
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
         hiding_free_open hiding_cofree_open
         hiding_np_free_open hiding_minimize_open
         hiding_free_proved hiding_cofree_proved
         hiding_np_free_proved hiding_minimize_proved).sample
    end

    pending { Faker::Boolean.boolean }

    after(:build) do |mapping|
      mapping.file_version = mapping.source.file_version
    end
  end
end
