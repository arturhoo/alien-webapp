require 'alien'
require 'yaml'
require_relative 'my_alien/tag_list'
require_relative 'my_alien/notifier'

module MyAlien

  config_file   = YAML.load_file 'config.yml'
  @@reader_addr = config_file['reader_addr']
  @@app_addr    = config_file['app_addr']

  def self.reader_addr; @@reader_addr; end
  def self.app_addr;    @@app_addr;    end
end
