require 'spec_helper'
require 'homer/github_layer'

describe GitHubLayer do

  describe "create_token" do
    context "invalid credentials" do
      it "should raise exception" do
        github = double('GitHub')
        Github.should_receive(:new).with(login: "login",password: "password").and_return(github)
        github.should_receive(:oauth).and_raise(Github::Error::Unauthorized.new({})) 
        expect { GitHubLayer.login("login","password") }.to raise_error "Invalid GitHub Login/Password"
      end
    end
    context "valid credentials" do
      it "should save the authorization token" do
        github = double('GitHub').as_null_object
        Github.should_receive(:new).with(login: "login", password: "password").and_return(github)
        github.stub_chain(:oauth, :create).and_return Hashie::Mash.new({"token" => "received_token" })
        FileLayer.should_receive(:save_authorization_token).with("received_token")
        GitHubLayer.login("login","password")
      end
    end
  end

  describe "create_repo" do
    it "should create a repository"
  end

  describe "initialization" do
    it "should log in to github account with login and password"
    describe "handling dotfiles repo" do
      context "when dotfiles repo already exists" do
        context "when homer folder does not exist inside the dotfiles repo" do
          it "should create the directory"
        end
        context "when homer folder does not exist inside the dotfiles repo" do
          it "should ask the user what to do"
        end
      end
      context "when dotfiles repo does not exist" do
        it "should create the repo"
      end
    end
  end
  
end
