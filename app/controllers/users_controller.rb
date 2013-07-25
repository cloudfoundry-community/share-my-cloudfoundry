class UsersController < ApplicationController

  ##
  # Creates a new User and assigns an Organization and Space to the user
  #
  def create
    user_email = get_user_email

    # Create User
    user_random_password = SecureRandom.urlsafe_base64(8)
    begin
      user = User.new.create(user_email, user_random_password)
    rescue CFoundry::UAAError => e
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

  ##
  # Retrieves the User email
  #
  # @return [String] User email
  def get_user_email
    return params['email'] unless auth_hash

    case auth_hash.provider
      when 'twitter'
        auth_hash.info.nickname
      else
        auth_hash.info.email
    end
  end

  ##
  # Returns OmniAuth Authentication Hash
  #
  # @return [Hash] OmniAuth Authentication Hash
  def auth_hash
    request.env['omniauth.auth']
  end
end
