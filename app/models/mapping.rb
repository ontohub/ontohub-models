# frozen_string_literal: true

# A mapping uses a signature morphism to map an OMS to another
class Mapping < LocIdBase
  many_to_one :source, class: OMS
  many_to_one :target, class: OMS
  many_to_one :signature_morphism
  many_to_one :cons_status
  many_to_one :freeness_parameter_oms, class: OMS
  many_to_one :freeness_parameter_language, class: Language
end
