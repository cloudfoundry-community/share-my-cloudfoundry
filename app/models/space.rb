class Space < CfClient

  ##
  # Creates a new Space
  #
  # @param [String] space_name Name of the new Space
  # @param [CFoundry::V2::Organization] organization Parent Organization
  # @param [CFoundry::V2::User] user User to add to the Space
  # @return [CFoundry::V2::Space] Space
  def create(space_name, organization, user = nil)
    space = client.space
    space.organization = organization
    space.name = space_name
    space.create!

    add_user(space, user) if user

    space
  end

  ##
  # Add a User to a Space
  #
  # @param [CFoundry::V2::Space] space Space
  # @param [CFoundry::V2::User] user User to add to the Space
  # @return [void]
  def add_user(space, user)
    space.add_manager user
    space.add_developer user
    space.add_auditor user
  end

end