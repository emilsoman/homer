require 'spec_helper'
require 'homer/dotfiles'

describe Homer::Dotfiles, fakefs: true do
  let(:dotfiles) { Homer::Dotfiles.new(gh_address)  }

  describe "#use" do
    include DotfilesHelper

    let(:gh_address) { 'emilsoman/dotfiles' }

    it "should set up symlinks as per Homerfile" do
      setup_dotfiles(gh_address)
      expect(dotfiles).to receive(:clone_or_update)

      dotfiles.use
      dotfiles_should_be_symlinked_to(gh_address)
    end
  end
end
