# frozen_string_literal: true

# Superclass of FileVersion
class LocIdBase < Sequel::Model
  plugin :timestamps
  plugin :validation_helpers
  plugin :class_table_inheritance, key: :kind, alias: :loc_id_bases

  include ModelWithURL
end
