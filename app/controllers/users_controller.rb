class UsersController < ApplicationController

  DEFAULT_SPACE_NAME = 'development'

  ##
  # Creates a new User and assigns an Organization and Space to the user
  #
  # @return [void]
  def create
    user_name = get_user_email
    user_password = SecureRandom.urlsafe_base64(8)
    user = create_user(user_name, user_password)
    if user
      organization = create_organization(user)
      space = create_space(organization, user)
    end

    respond_to do |format|
      if user
        @user_email = user_name
        @user_password = user_password
        @organization_name = organization.name
        @space_name = space.name
        format.html { render action: 'show' }
      else
        format.html { redirect_to sessions_url, alert: "User #{user_name} is already registered"}
      end
    end
  end

  private

  ##
  # Creates an User
  #
  # @param [String] user_name User name
  # @param [String] user_password User password
  # @return [CFoundry::V2::User] User
  def create_user(user_name, user_password)
    begin
      user = User.new.create(user_name, user_password)
    rescue CFoundry::UAAError => e
      user = nil if e.message =~ /scim_resource_already_exists/
    end

    user
  end

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

  ##
  # Creates (or reuses) an Organization and adds Users and Roles
  #
  # @param [CFoundry::V2::User] user User to assign Roles in the Spac
  # @return [CFoundry::V2::Organization] Organization
  def create_organization(user)
    if Figaro.env.respond_to?(:cf_organization)
      organization = Organization.new.get(Figaro.env.cf_organization)
    end

    unless organization
      organization_prefix = '0'
      organization_name = user.name.split('@')[0]
      begin
        organization = Organization.new.create(organization_name)
      rescue CFoundry::OrganizationNameTaken
        organization_name = user.name.split('@')[0] + organization_prefix.succ!
        retry
      end
    end

    Organization.new.add_user(organization, user)
    Organization.new.assign_roles(organization, user, organization_roles) if organization_roles.any?

    organization
  end

  ##
  # Retrieves the Roles to assign to Users in an Organization
  #
  # @return [Array<String>] Arrays of roles to assign to users in an Organization
  def organization_roles
    roles = []

    if Figaro.env.respond_to?(:cf_organization_add_manager) &&
       Figaro.env.cf_organization_add_manager.downcase == 'true'
      roles << 'manager'
    end

    if Figaro.env.respond_to?(:cf_organization_add_billing_manager) &&
       Figaro.env.cf_organization_add_billing_manager.downcase == 'true'
      roles << 'billing_manager'
    end

    if Figaro.env.respond_to?(:cf_organization_add_auditor) &&
       Figaro.env.cf_organization_add_auditor.downcase == 'true'
      roles << 'auditor'
    end

    roles
  end

  ##
  # Creates (or reuses) a Space and adds Roles to a User in the Space
  #
  # @param [CFoundry::V2::Organization] organization Parent Organization
  # @param [CFoundry::V2::User] user User to assign Roles in the Space
  # @return [CFoundry::V2::Space] Space
  def create_space(organization, user)
    space_name = Figaro.env.respond_to?(:cf_space) ? Figaro.env.cf_space : DEFAULT_SPACE_NAME
    space = Space.new.get(space_name, organization)
    space = Space.new.create(space_name, organization) unless space

    Space.new.assign_roles(space, user, space_roles) if space_roles.any?

    space
  end

  ##
  # Retrieves the Roles to assign to Users in a Space
  #
  # @return [Array<String>] Arrays of roles to assign to users in a Space
  def space_roles
    roles = []

    if Figaro.env.respond_to?(:cf_space_add_manager) &&
       Figaro.env.cf_space_add_manager.downcase == 'true'
      roles << 'manager'
    end

    if Figaro.env.respond_to?(:cf_space_add_developer) &&
       Figaro.env.cf_space_add_developer.downcase == 'true'
      roles << 'developer'
    end

    if Figaro.env.respond_to?(:cf_space_add_auditor) &&
       Figaro.env.cf_organization_add_auditor.downcase == 'true'
      roles << 'auditor'
    end

    roles
  end

end
