require 'homer/file_layer'

class Homer

  class << self

    def init
      FileLayer.prepare_homer_folder
    end

    def wipe
      FileLayer.delete_homer_folder
    end

    def add(dotfile)
      FileLayer.add_filename_to_dotfiles(dotfile)
    end

    def list
      FileLayer.read_dotfiles
    end

  end

end

