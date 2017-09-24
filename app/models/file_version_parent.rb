# frozen_string_literal: true

# Maps a commit_sha of a commit that may or may not have changed a file to the
# FileVersion that actually has changed the file the last time.
class FileVersionParent < Sequel::Model
  # The primary key is compound (last_changed_file_version_id, queried_sha).
  # Allow to set these in mass assignment.
  unrestrict_primary_key

  many_to_one :last_changed_file_version, class: FileVersion
end
