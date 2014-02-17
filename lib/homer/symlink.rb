require 'homer/errors'
module Homer
  class Symlink
    class << self
      def create(file, home_relative_path)
        #Move 'path' to backup
        if !File.exists?(file)
          say "<%= color('#{file} does not exist. Can't symlink this file.', :red) %>"
          return
        end
        file_path = File.expand_path(home_relative_path)
        if File.exists?(file_path)
          if File.symlink?(file_path)
            say "<%= color('Symlink already exists at #{file_path}. Overwriting with #{file}', :yellow) %>"
            File.unlink(file_path)
          else
            say "<%= color('File already exists at #{file_path}. Not linking #{file}', :red) %>"
            return
          end
        end
        FileUtils.mkdir_p(File.dirname(file_path)) unless Dir.exists?(File.dirname(file_path))
        File.symlink(file, file_path)
      end
    end
  end
end
