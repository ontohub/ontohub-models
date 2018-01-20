# frozen_string_literal: true

# The Repository model groups libraries and exposes the basic git functinoality.
class Repository < Sequel::Model
  SLUG_BLACKLIST = %w(repositories organizations members settings).freeze
  CONTENT_TYPES = %w(ontology model specification mathematical).freeze
  REMOTE_TYPES = %(fork mirror).freeze

  plugin :validation_helpers

  include Slug
  slug_base :name
  slug_condition :new?
  slug_postprocess ->(slug) { "#{owner&.slug}/#{slug}" }
  slug_format %r{\A([a-z0-9\-_]+)/([a-z0-9\-_]+)\z}

  many_to_one :owner, class: OrganizationalUnit

  one_to_many :repository_memberships
  many_to_many :members, join_table: :repository_memberships, class: User

  one_to_many :file_versions
  plugin :association_dependencies, file_versions: :destroy

  one_to_many :url_mappings

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def validate
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
    validates_length_range (3..100), :name
    if SLUG_BLACKLIST.include?(slug.split('/', 2).last)
      errors.add(:name, "cannot be '#{name}'")
    end
    validates_presence :owner
    validates_presence :public_access
    validates_includes CONTENT_TYPES, :content_type
    validates_presence :remote_type if remote_address.present?
    validates_presence :remote_address if remote_type.present?
    validates_includes REMOTE_TYPES, :remote_type unless remote_type.nil?
    super
  end

  def add_member(member, role = 'read')
    repository_membership = RepositoryMembership.first(member: member,
                                                       repository: self)
    if repository_membership
      repository_membership.role = role
      repository_membership.save
    else
      RepositoryMembership.create(member: member, repository: self, role: role)
    end
  end

  def remove_member(member)
    RepositoryMembership.first(member: member, repository: self).destroy
  end
end
