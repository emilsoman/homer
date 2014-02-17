require 'homer/errors'

module Homer
  class Github
    attr_reader :username, :repo_name

    def self.parse_address(gh_address)
      gh_address.split('/').tap do |x|
        raise AddressParseError, "#{gh_address} cannot be parsed" if x.size != 2
      end
    end

    def initialize(gh_address)
      @gh_address = gh_address
    end

    #def create_repo(password, repo_name)
      #github = Github.new(login: @username, password: password)
      #begin
        #github.repos.create(name: repo_name)
      #rescue Github::Error::GithubError
        #say "<%= color('Repository - #{repo_name} already exists under #{@username}, we will see if we can use that.', :yellow) %>"
      #end
    #end

    def clone(clone_directory)
      repo_url = "git://github.com/#{@gh_address}.git"
      #set_remote_url_cmd = "git remote set-url --push origin git@github.com:#{username}/#{repo_name}.git"
      system("git clone --quiet #{repo_url} #{clone_directory}")# &&
        #system(set_remote_url_cmd)
    end

    def update
      system("git pull origin master")
    end

    #def sync
      #system("git add --all")
      #system("git commit -m 'Updated dotfiles'")
      #system("git pull")
      #system("git push origin master")
    #end
  end
end
