class Space < CfClient

  ##
  # Returns a Space
  #
  # @param [String] space_name Name of the Space
  # @param [CFoundry::V2::Organization] organization Parent Organization
  # @return [CFoundry::V2::Space] Space
  def get(space_name, organization)
    organization.spaces.find { |s| s.name == space_name }
  end

  ##
  # Creates a new Space
  #
  # @param [String] space_name Name of the new Space
  # @param [CFoundry::V2::Organization] organization Parent Organization
  # @return [CFoundry::V2::Space] Space
  def create(space_name, organization)
    space = client.space
    space.name = space_name
    space.organization = organization
    space.create!

    space
  end

  ##
  # Assigns a Role to a User in a Space
  #
  # @param [CFoundry::V2::Space] space Space
  # @param [CFoundry::V2::User] user User to assign the Role
  # @parma [Array<String>] space_roles Roles to assign to the User
  # @return [void]
  def assign_roles(space, user, space_roles)
    space.add_manager user if space_roles.include?('manager')
    space.add_developer user if space_roles.include?('developer')
    space.add_auditor user if space_roles.include?('auditor')
  end

end
