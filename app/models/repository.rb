class Repository < Sequel::Model
  plugin :timestamps

	include Slug
  slug_base :name
  slug_condition :new?
end
