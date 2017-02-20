# frozen_string_literal: true

# A specific commit belongs to a repository and can have many file versions.
class Commit < Sequel::Model
  include ModelWithURL

  plugin :timestamps
  plugin :validation_helpers

  many_to_one :repository
  one_to_many :file_versions
  many_to_one :author, class: :User
  many_to_one :committer, class: :User
  many_to_one :pusher, class: :User

  def author_email=(author_email)
    super(author_email)
    self.author = User.find(email: author_email)
  end

  def committer_email=(committer_email)
    super(committer_email)
    self.committer = User.find(email: committer_email)
  end

  def validate
    validates_presence :pusher
    super
  end
end
