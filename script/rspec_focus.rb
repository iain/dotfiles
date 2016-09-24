RSpec.configure do |config|
  config.reset
  config.formatter = "documentation"
  formatters = config.formatters
  formatters.singleton_class.send(:define_method, :<<) { |*| }
  config.singleton_class.send(:define_method, :formatters) { formatters }
end
