# frozen_string_literal: true

# The NativeDocument contains exactly one OMS
class NativeDocument < Document
  one_to_one :oms, class: OMS, key: :document_id
end
