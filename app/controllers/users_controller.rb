class UsersController < ApplicationController

  def show

  end

  ##
  # Creates a new User and assigns an Organization and Space to the user
  #
  def create
    # Create User
    user_email = params['email']
    user_random_password = SecureRandom.urlsafe_base64(8)
    begin
      user = User.new.create(user_email, user_random_password)
    rescue CFoundry::UAAError => e
      Rails.logger.debug(user.inspect)
      user = nil if e.message =~ /scim_resource_already_exists/
    end

    if user
      # Create organization
      user_prefix = '0'
      organization_name = user_email.split('@')[0]
      begin
        organization = Organization.new.create(organization_name, user)
      rescue CFoundry::OrganizationNameTaken
        organization_name = user_email.split('@')[0] + user_prefix.succ!
        retry
      end

      # Create Space
      space = Space.new.create('development', organization, user)

      # Fill instance vars
      @user_email = user_email
      @user_password = user_random_password
      @organization_name = organization.name
      @space_name = space.name
    end

    respond_to do |format|
      format.html { render action: 'show' }
    end
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end