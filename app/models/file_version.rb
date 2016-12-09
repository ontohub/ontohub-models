# frozen_string_literal: true

# Represents a specific version of a file.
class FileVersion < Sequel::Model
  plugin :timestamps

  many_to_one :commit
end
