Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_KEY'],  ENV['FACEBOOK_SECRET']
  provider :github,   ENV['GITHUB_KEY'],    ENV['GITHUB_SECRET']
  provider :twitter,  ENV['TWITTER_KEY'],   ENV['TWITTER_SECRET']
  provider :att,      ENV['ATT_CLIENT_ID'], ENV['ATT_CLIENT_SECRET'], :site => ENV['ATT_BASE_DOMAIN'], :callback_url => ENV['ATT_CALLBACK_URL']
end