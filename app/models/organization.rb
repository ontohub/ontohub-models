# frozen_string_literal: true

# The class representing an actual Organization
class Organization < OrganizationalUnit
  many_to_many :members, class: User, join_table: :organization_memberships
  one_to_many :organization_memberships

  plugin :association_dependencies, members: :nullify

  def add_member(member, role = 'read')
    organization_membership = OrganizationMembership.
      find(member: member,  organization: self)
    if organization_membership
      organization_membership.role = role
      organization_membership.save
    else
      OrganizationMembership.
        new(member: member, organization: self, role: role).save
    end
  end

  def remove_member(member)
    OrganizationMembership.find(member: member, organization: self).destroy
  end
end
