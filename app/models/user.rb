# frozen_string_literal: true

# The class representing an actual user
class User < OrganizationalUnit
  plugin :devise

  devise :database_authenticatable

  def personal_repositories
    Repository.
      graph(:namespaces, {id: :namespace_id}, select: false).
      where(namespaces__organizational_unit_id: id)
  end
end
