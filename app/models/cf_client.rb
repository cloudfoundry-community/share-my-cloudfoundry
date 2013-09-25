class CfClient

  attr_accessor :client

  ##
  # Initializes the CF client
  #
  # @return [void]
  def initialize
    @client = CFoundry::Client.get(Figaro.env.cf_endpoint)
    @client.login(username: Figaro.env.cf_admin_user, password: Figaro.env.cf_admin_password)
  end
end
