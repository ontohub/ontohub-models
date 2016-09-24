class User < OrganizationalUnit
  plugin :devise

  devise :database_authenticatable

  def personal_repositories
    Repository.
      graph(:namespaces, {id: :namespace_id}, select: false).
      where(namespaces__organizational_unit_id: id)
  end

  def groups_repositories
    Repository.
      graph(:namespaces, {id: :namespace_id}, select: false).
      graph(:group_memberships,
            {group_id: :namespaces__organizational_unit_id},
            select: false).
      where(group_memberships__user_id: id)
  end
end
