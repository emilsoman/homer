require 'github_api'
require 'homer/file_layer'
Github::Authorizations::VALID_AUTH_PARAM_NAMES = Github::Authorizations::VALID_AUTH_PARAM_NAMES + ["note"]

class GitHubLayer
  class << self

    def login(login, password)
      github = Github.new(login: login, password: password)
      authorization = github.oauth.create(scopes: ['public_repo'], note: 'Homer')
      FileLayer.save_authorization_token(authorization.token)
    rescue Github::Error::Unauthorized
      raise "Invalid GitHub Login/Password"
    end

    def create_repo
      
    end

  end
end
