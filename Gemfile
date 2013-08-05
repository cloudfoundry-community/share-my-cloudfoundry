source 'https://rubygems.org'

# FIXME: Not supported if running this app on Cloud Foundry v1
# ruby '1.9.3'

gem 'rails', '3.2.13'

gem 'bootstrap-sass'
gem 'figaro'
gem 'haml-rails'
gem 'jquery-rails'
gem 'sqlite3'
gem 'thin'
gem 'turbolinks'

# What is the target Cloud Foundry version?
if ENV["V1"]
  gem 'cfoundry', '= 0.4.9'
else
  gem 'cfoundry', '>= 4.0.1'
end

gem 'omniauth-facebook'
gem 'omniauth-github'
# gem 'omniauth-linkedin-oauth2'
gem 'omniauth-twitter'
gem 'omniauth-uaa-oauth2', :git => 'https://github.com/cloudfoundry/omniauth-uaa-oauth2.git'
gem 'omniauth-att', :git => 'https://github.com/att-innovate/omniauth-att.git'
gem 'recaptcha', :require => 'recaptcha/rails'

group :assets do
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'sass-rails'

  # CF v1 needs a execjs runtime
  # see https://github.com/sstephenson/execjs
  gem 'therubyracer', :platform => :ruby
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_19, :rbx]
  gem 'html2haml'
  gem 'quiet_assets'
end
