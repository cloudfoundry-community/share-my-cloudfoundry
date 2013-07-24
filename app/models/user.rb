class User < CfClient

  ##
  # Creates a new User
  #
  # @param [String] email User email
  # @param [String] password User password
  # @return [CFoundry::V2::User] User
  def create(email, password)
    user = client.register(email, password)

    user
  end

  ##
  # Gets info about a user
  #
  # @param [String] email User email
  # @return [CFoundry::V2::User] User
  def get(email)
    user = client.base.uaa.users[:resources].find { |r| r[:username] == email }

    user
  end

  ##
  # Resets a User Password
  #
  # @param [String] email User email
  # @param [String] password New User password
  # @return [void] User
  def reset_password(email, password)
    # TODO
  end

end