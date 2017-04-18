# frozen_string_literal: true

# Represents a specific version of a file.
class FileVersion < LocIdBase
  include ModelWithURL

  plugin :timestamps
  plugin :validation_helpers

  many_to_one :repository

  def validate
    validates_presence :repository
    validates_presence :commit_sha
    validates_format(/\A[a-f0-9]{40}\z/, :commit_sha)
    validates_presence :path
    super
  end
end
