# frozen_string_literal: true

# The DocumentLink association model
class DocumentLink < Sequel::Model
  many_to_one :source, class: Document
  many_to_one :target, class: Document
end
