class User < CfClient

  ##
  # Gets info about a user
  #
  # @param [String] user_name User name
  # @return [Hash] User info as returned by UAA
  def get(user_name)
    client.base.uaa.users[:resources].find { |r| r[:username] == user_name }
  end

  ##
  # Creates a new User
  #
  # @param [String] user_name User name
  # @param [String] user_password User password
  # @return [CFoundry::V2::User] User
  def create(user_name, user_password)
    client.register(user_name, user_password)
  end

  ##
  # Change a User Password
  #
  # @param [String] user_name User name
  # @param [String] user_password User new password
  # @return [void]
  def change_password(user_name, user_password)
    # TODO
  end

end
