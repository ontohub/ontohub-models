# frozen_string_literal: true

# The Repository model groups libraries and exposes the basic git functinoality.
class Repository < Sequel::Model
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

  def validate
    validates_length_range (3..100), :name
    validates_presence :owner
    validates_presence :public_access
    validates_includes %w(ontology model specification mathematical),
      :content_type
    super
  end

  def add_member(member, role = 'read')
    repository_membership = RepositoryMembership.find(member: member,
                                                      repository: self)
    if repository_membership
      repository_membership.role = role
      repository_membership.save
    else
      RepositoryMembership.new(member: member, repository: self, role: role).save
    end
  end

  def remove_member(member)
    RepositoryMembership.find(member: member, repository: self).destroy
  end
end
