class UsersController < ApplicationController

  DEFAULT_SPACE_NAME = 'development'

  ##
  # Creates a new User and assigns an Organization and Space to the user
  #
  # @return [void]
  def create
    if user_name = get_user_email
      user_password = SecureRandom.urlsafe_base64(8)
      if user = create_user(user_name, user_password)
        organization = create_organization(user)
        space = create_space(organization, user)
      end
    end

    respond_to do |format|
      if user
        @user_email = user_name
        @user_password = user_password
        @organization_name = organization.name
        @space_name = space.name
        format.html { render action: 'show' }
      else
        format.html { render 'sessions/new' }
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
      user = nil
      if e.message =~ /scim_resource_already_exists/
        error_message = "User #{user_name} is already registered"
        if Figaro.env.respond_to?(:cf_password_reset_url)
          error_message << ' (' + view_context.link_to('Forgot password?', Figaro.env.cf_password_reset_url) + ')'
        end
        flash[:error] = error_message.html_safe
      else
        flash[:error] = e.message
      end
    end

    user
  end

  ##
  # Retrieves the User email
  #
  # @return [String] User email
  def get_user_email
    unless auth_hash
      return nil if recaptcha_enabled? && !verify_recaptcha
      return params['email']
    end

    case auth_hash.provider
      when 'twitter'
        auth_hash.info.nickname
      when 'github'
        check_user_github_organizations ? auth_hash.info.email : nil
      else
        auth_hash.info.email
    end
  end

  ##
  # Checks if a user belongs to a github organization
  #
  # @return [Boolean]
  def check_user_github_organizations
    if Figaro.env.respond_to?(:github_organization)
      github_orgs_url = auth_hash.extra.raw_info.organizations_url + '?access_token=' + auth_hash.credentials.token
      user_organizations = get_user_github_organizations(github_orgs_url)
      unless user_organizations.include?(Figaro.env.github_organization)
        flash[:error] = "You are not a member of the github organization '#{Figaro.env.github_organization}'"
        logger.error "User email '#{get_user_email}' is not in github organization '#{Figaro.env.github_organization}'"
        return false
      end
    end

    true
  end

  ##
  # Gets all organizations a user belong to.
  #
  # @param [String] Github Organizations API URL
  # @return [Array<String>] Organizations
  def get_user_github_organizations(github_orgs_url)
    uri = URI.parse(github_orgs_url)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    response = http.request(Net::HTTP::Get.new(uri.request_uri))

    user_organizations = JSON.parse(response.body)
    user_organizations.map { |o| o['login'] }
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
      organization_name = user.email.split('@')[0]
      begin
        organization = Organization.new.create(organization_name)
      rescue CFoundry::OrganizationNameTaken
        organization_name = user.email.split('@')[0] + organization_prefix.succ!
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
