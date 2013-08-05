Rails.application.config.middleware.use OmniAuth::Builder do
  provider :att, ENV['ATT_CLIENT_ID'], ENV['ATT_CLIENT_SECRET'], :scope => 'profile'
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'], :scope => 'email'
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], :scope => 'user:email'
  provider :linkedin_oauth2, ENV['LINKEDIN_KEY'], ENV['LINKEDIN_SECRET'], :scope => 'r_emailaddress'
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  provider :cloudfoundry, ENV['CF_UAA_KEY'], ENV['CF_UAA_SECRET'], {
    :auth_server_url  => ENV['CF_UAA_AUTH_SERVER_URL'],
    :token_server_url => ENV['CF_UAA_TOKEN_SERVER_URL']
  }
end

OmniAuth.config.full_host = ENV['OMNIAUTH_FULL_HOST'] if ENV['OMNIAUTH_FULL_HOST']
OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}
