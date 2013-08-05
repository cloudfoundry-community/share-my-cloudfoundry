module ApplicationHelper

  ##
  # Returns if register by Email is enabled
  #
  # @return [Boolean] True/False
  def email_register_enabled?
    return true unless Figaro.env.respond_to?(:email_register_enabled)
    Figaro.env.email_register_enabled.downcase == 'true'
  end

  ##
  # Returns if register by Facebook is enabled
  #
  # @return [Boolean] True/False
  def facebook_register_enabled?
    Figaro.env.respond_to?(:facebook_key) && Figaro.env.respond_to?(:facebook_secret)
  end

  ##
  # Returns if register by Github is enabled
  #
  # @return [Boolean] True/False
  def github_register_enabled?
    Figaro.env.respond_to?(:github_key) && Figaro.env.respond_to?(:github_secret)
  end

  ##
  # Returns if register by Linkedin is enabled
  #
  # @return [Boolean] True/False
  def linkedin_register_enabled?
    Figaro.env.respond_to?(:linkedin_key) && Figaro.env.respond_to?(:linkedin_secret)
  end

  ##
  # Returns if register by Twitter is enabled
  #
  # @return [Boolean] True/False
  def twitter_register_enabled?
    Figaro.env.respond_to?(:twitter_key) && Figaro.env.respond_to?(:twitter_secret)
  end

  ##
  # Returns if register by ATT is enabled
  #
  # @return [Boolean] True/False
  def att_register_enabled?
    Figaro.env.respond_to?(:att_client_id) && Figaro.env.respond_to?(:att_client_secret)
  end

  ##
  # Returns if register by Cloud Foundry UAA is enabled
  #
  # @return [Boolean] True/False
  def cf_uaa_register_enabled?
    Figaro.env.respond_to?(:cf_uaa_key) && Figaro.env.respond_to?(:cf_uaa_secret) &&
    Figaro.env.respond_to?(:cf_uaa_auth_server_url) && Figaro.env.respond_to?(:cf_uaa_token_server_url)
  end

end
