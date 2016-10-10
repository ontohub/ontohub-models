# frozen_string_literal: true

# The namespace is used to group repositories by the owner and to allow setting
# repository-local permissions for teams and users.
class Namespace < Sequel::Model
  plugin :timestamps

  many_to_one :organizational_unit
  one_to_many :repositories
  plugin :association_dependencies, repositories: :destroy

  delegate :slug, to: :organizational_unit
  delegate :name, to: :organizational_unit

  # Overwrite find to allow finding via slug, even though the slug is in
  # another table. This simplifies the controller.
  def self.find(**opts)
    if slug = opts.delete(:slug)
      # Find by slug via join table.
      graph(:organizational_units, {id: :organizational_unit_id},
              select: false).
        where(organizational_units__slug: slug, **opts).first
    else
      # Call the original implementation
      Namespace[**opts]
    end
  end

  def to_param
    slug
  end
end
