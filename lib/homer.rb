require 'homer/file_layer'
require 'homer/symlink'

class Homer

  class << self

    def init
      FileLayer.prepare_homer_folder
    end

    def wipe
      FileLayer.delete_homer_folder
    end

    def add(dotfile)
      SymLink.add(dotfile)
    end

    def list
      SymLink.filenames
    end

  end

end

