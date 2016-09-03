class Repository < Sequel::Model
  plugin :timestamps
  plugin :validation_helpers

  include Slug
  slug_base :name
  slug_condition :new?

  def validate
    validates_presence :name
    validates_length_range (3..100), :name
    validates_unique :slug
    validates_format /\A[a-z0-9-]+\z/, :slug
    super
  end
end
