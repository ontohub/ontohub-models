# frozen_string_literal: true

require 'git/cloning'
require 'git/committing'
require 'git/pulling'
require 'popen'

# This class encapsulates all git related functionality.
class Git
  extend Git::Cloning::ClassMethods
  include Git::Committing
  include Git::Pulling

  attr_reader :gitlab
  delegate :bare?, :branches, :branch_count, :branch_exists?, :branch_names,
           :commit_count, :find_commits, :empty?, :log, :ls_files,
           :repo_exists?,
           to: :gitlab

  def self.create(path)
    Rugged::Repository.init_at(path, :bare)
    new(path)
  end

  def self.destroy(path)
    new(path.to_s).gitlab.repo_exists? && FileUtils.rm_rf(path)
  end

  def initialize(path)
    @gitlab = Gitlab::Git::Repository.new(path.to_s)
  end

  def path
    Pathname.new(gitlab.
                 instance_variable_get(:@attributes).
                 instance_variable_get(:@path))
  end

  # Query for a blob
  def blob(ref, path)
    Gitlab::Git::Blob.find(gitlab, ref, path)
  end

  # Query for a tree
  def tree(ref, path)
    Gitlab::Git::Tree.where(gitlab, ref, path)
  end

  def commit(ref)
    Gitlab::Git::Commit.find(gitlab, ref)
  end

  # Query for a tree
  def path_exists?(ref, path)
    !blob(ref, path).nil? || tree(ref, path).any?
  end

  def branch_sha(name)
    gitlab.find_branch(name)&.dereferenced_target&.sha
  end

  # Create a branch with name +name+ at the reference +ref+.
  def create_branch(name, ref)
    gitlab.create_branch(name, ref)
  end
end
