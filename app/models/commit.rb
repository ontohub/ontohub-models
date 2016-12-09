# frozen_string_literal: true

# A specific commit belongs to a repository and can have many file versions.
class Commit < Sequel::Model
  plugin :timestamps

  many_to_one :repository
  one_to_many :file_version
  many_to_one :author, key: :author_id, class: :User
  many_to_one :editor, key: :editor_id, class: :User
end
