# frozen_string_literal: true

# A mapping uses a signature morphism to map an OMS to another
class Mapping < LocIdBase
  ORIGINS = %w(see_target see_source test dg_link_verif dg_implies_link
               dg_link_extension dg_link_translation dg_link_closed_lenv
               dg_link_imports dg_link_intersect dg_link_morph dg_link_inst
               dg_link_inst_arg dg_link_view dg_link_align dg_link_fit_view
               dg_link_fit_view_imp dg_link_proof dg_link_flattening_union
               dg_link_flattening_rename dg_link_refinement).freeze

  TYPES = %w(local_def local_thm_open local_thm_proved
             global_def global_thm_open global_thm_proved
             hiding_def
             free_def cofree_def np_free_def minimize_def
             hiding_open hiding_proved
             free_open cofree_open np_free_open minimize_open
             free_proved cofree_proved np_free_proved minimize_proved).freeze

  plugin :validation_helpers

  many_to_one :source, class: OMS
  many_to_one :target, class: OMS
  many_to_one :signature_morphism
  many_to_one :conservativity_status
  many_to_one :freeness_parameter_oms, class: OMS
  many_to_one :freeness_parameter_language, class: Language

  def validate
    validates_includes ORIGINS, :origin
    validates_includes TYPES, :type
    super
  end
end
