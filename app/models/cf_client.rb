class CfClient

  attr_accessor :client

  ##
  # Initializes the CF client
  #
  # @return [void]
  def initialize
    endpoint = Figaro.env.cf_endpoint
    credentials = {version: 2, token: Figaro.env.cf_token, refresh_token: Figaro.env.cf_refresh_token}
    token = CFoundry::AuthToken.from_hash(credentials)
    @client = CFoundry::Client.get(endpoint, token)
  end
end