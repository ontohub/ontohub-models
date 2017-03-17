# frozen_string_literal: true

# Represents a specific version of a file.
class FileVersion < LocIdBase
  include ModelWithURL

  plugin :timestamps
  plugin :validation_helpers

  def validate
    validates_presence :commit_sha
    validates_presence :path
    super
  end
end
