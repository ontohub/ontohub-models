# frozen_string_literal: true

# Superclass of FileVersion
class LocIdBase < Sequel::Model
  plugin :validation_helpers
  plugin :class_table_inheritance, key: :kind, alias: :loc_id_bases

  def validate
    validates_presence :loc_id
    validates_format %r{\A/}, :loc_id
    super
  end
end
