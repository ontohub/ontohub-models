# frozen_string_literal: true

# The Repository model groups libraries and exposes the basic git functinoality.
class Repository < Sequel::Model
  plugin :timestamps
  plugin :validation_helpers

  include ModelWithURL

  include Slug
  slug_base :name
  slug_condition :new?
  slug_postprocess ->(slug) { "#{organizational_unit&.slug}/#{slug}" }
  slug_format %r{\A([a-z0-9\-_]+)/([a-z0-9\-_]+)\z}

  many_to_one :organizational_unit

  def validate
    validates_length_range (3..100), :name
    validates_presence :organizational_unit_id
    validates_presence :public_access
    validates_includes %w(ontology model specification), :content_type
    super
  end
end
