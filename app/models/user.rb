# frozen_string_literal: true

# The class representing an actual user
class User < OrganizationalUnit
  plugin :devise

  devise :database_authenticatable
end
