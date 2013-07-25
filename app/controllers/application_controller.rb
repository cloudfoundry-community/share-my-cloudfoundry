class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :recaptcha_enabled?

  ##
  # Returns if Recaptcha is enabled
  #
  # @return [Boolean] True/False
  def recaptcha_enabled?
    Figaro.env.respond_to?(:recaptcha_public_key) && Figaro.env.respond_to?(:recaptcha_private_key)
  end

end
