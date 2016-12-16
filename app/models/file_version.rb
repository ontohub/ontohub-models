# frozen_string_literal: true

# Represents a specific version of a file.
class FileVersion < Sequel::Model
  include ModelWithURL

  plugin :timestamps
  plugin :validation_helpers

  many_to_one :commit

  def validate
    validates_presence :commit
    super
  end
end
