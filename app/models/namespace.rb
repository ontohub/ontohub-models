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
end
