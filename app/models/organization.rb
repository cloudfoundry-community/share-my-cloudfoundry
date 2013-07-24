class Organization < CfClient

  ##
  # Creates a new Organization
  #
  # @param [String] organization_name Name of the new Organization
  # @param [CFoundry::V2::User] user User to add to the Organization
  # @return [CFoundry::V2::Organization] Organization
  def create(organization_name, user)
    organization = client.organization
    organization.name = organization_name
    organization.users = [user] if user
    organization.create!

    organization
  end

end