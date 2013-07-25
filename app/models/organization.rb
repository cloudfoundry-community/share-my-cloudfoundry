class Organization < CfClient

  ##
  # Returns an Organization
  #
  # @param [String] organization_name Name of the Organization
  # @return [CFoundry::V2::Organization] Organization
  def get(organization_name)
    client.organization_by_name(organization_name)
  end

  ##
  # Creates a new Organization
  #
  # @param [String] organization_name Name of the new Organization
  # @return [CFoundry::V2::Organization] Organization
  def create(organization_name)
    organization = client.organization
    organization.name = organization_name
    organization.create!

    organization
  end

  ##
  # Adds a User to an Organization
  #
  # @param [CFoundry::V2::Organization] organization Organization
  # @param [CFoundry::V2::User] user User to add to the Organization
  # @return [void]
  def add_user(organization, user)
    organization.add_user user
  end

  ##
  # Assigns a Role to a User in an Organization
  #
  # @param [CFoundry::V2::Organization] organization Organization
  # @param [CFoundry::V2::User] user User to assign the role
  # @parma [Array<String>] organization_roles Roles to assign to the User
  # @return [void]
  def assign_roles(organization, user, organization_roles)
    organization.add_manager user if organization_roles.include?('manager')
    organization.add_billing_manager user if organization_roles.include?('billing_manager')
    organization.add_auditor user if organization_roles.include?('auditor')
  end

end
