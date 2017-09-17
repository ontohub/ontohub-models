# frozen_string_literal: true

# The Library can contain any number of OMS
class Library < Document
  one_to_many :oms, class: OMS, key: :document_id
end
