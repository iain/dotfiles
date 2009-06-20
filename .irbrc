# http://giantrobots.thoughtbot.com/2008/12/23/script-console-tips
require 'rubygems'
require 'wirble'
Wirble.init
Wirble.colorize

class Object
  def local_methods
    (methods - Object.instance_methods).sort
  end
end

alias q exit

if ENV.include?('RAILS_ENV') && !Object.const_defined?('RAILS_DEFAULT_LOGGER')
  require 'logger'
  RAILS_DEFAULT_LOGGER = Logger.new(STDOUT)
end

require 'pp'
