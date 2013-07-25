require "cf/cli"

module ShareMyCloudfoundry
  class SetupSharing < CF::CLI

    desc "Setup share-my-cloudfoundry application"
    group :admin
    def setup_sharing
    end
  end
end
