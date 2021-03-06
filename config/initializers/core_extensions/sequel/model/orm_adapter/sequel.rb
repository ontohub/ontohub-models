# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
class Sequel::Model
  # rubocop:enable Style/ClassAndModuleChildren
  # This is monkey-patching the get method to allow for class table inheritance.
  # orm_adapter-sequel's development is stale.
  # :nocov:
  class OrmAdapter < ::OrmAdapter::Base
    def get(id)
      column = Sequel[klass.table_name][klass.primary_key]
      klass.first(wrap_key(column => id))
    end
  end
  # :nocov:
end
