require 'spec_helper'

describe GitHub do

  let(:github_username) {'emilsoman'}
  let(:repo_name) {'dotfiles'}
  let(:github) {GitHub.new(github_username)}

  describe "#create_repo" do
    let(:password) {'password'}
    let(:github_api) {double('Github')}
    before(:each) do
    end
    context "when repo already exists in github" do
      it "should warn the users and continue without creating repo in github" do
        github_api.stub_chain(:repos, :create).and_raise(Github::Error::GithubError)
        Github.should_receive(:new).with({login: github_username, password: password}).and_return(github_api)
        github.should_receive(:say).with("<%= color('Repository - #{repo_name} already exists under #{github_username}, we will see if we can use that.', :yellow) %>")
        github.create_repo(password, repo_name)
      end
    end
    context "when repo doesn't exist in github" do
      it "should create repo in github" do
        github_api.stub_chain(:repos, :create)
        Github.should_receive(:new).with({login: github_username, password: password}).and_return(github_api)
        github.should_not_receive(:say).with("<%= color('Repository - #{repo_name} already exists under #{github_username}, we will see if we can use that.', :yellow) %>")
        github.create_repo(password, repo_name)
      end

    end
  end

  describe "#clone" do
    it 'should clone the repo and set the remote push url to a pushable SSH url' do
      clone_directory = '/home/emil/.homer/test/dotfiles'
      git_clone_cmd = "git clone --quiet git://github.com/#{github_username}/#{repo_name}.git #{clone_directory}"
      set_remote_url_cmd = "git remote set-url --push origin git@github.com:#{github_username}/#{repo_name}.git"
      github.should_receive('system').with(git_clone_cmd)
      github.should_receive('system').with(set_remote_url_cmd)
      github.clone(repo_name, clone_directory)
    end
  end

  describe "#sync" do
    it "should call system git commands to synnc with origin master" do
      github.should_receive(:system).with("git add --all")
      github.should_receive(:system).with("git commit -m 'Updated dotfiles'")
      github.should_receive(:system).with("git pull")
      github.should_receive(:system).with("git push origin master")
      github.sync
    end
  end

end
