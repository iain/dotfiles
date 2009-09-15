# Special thanks to Thoughtbot for this file
# http://giantrobots.thoughtbot.com/2008/12/23/script-console-tips

# Wirble is for colors in irb
require 'rubygems'
require 'wirble'
Wirble.init
Wirble.colorize

# Hirb is for pretty tables with ActiveRecord
require 'hirb'
Hirb.enable
extend Hirb::Console

# The local_methods is very handy
class Object
  def local_methods
    (methods - Object.instance_methods).sort
  end
end

alias q exit

# Show queries in script/console
if ENV.include?('RAILS_ENV') && !Object.const_defined?('RAILS_DEFAULT_LOGGER')
  require 'logger'
  RAILS_DEFAULT_LOGGER = Logger.new(STDOUT)
end

require 'pp'
require 'yaml'
