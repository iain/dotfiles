RSpec.configure do |config|
  config.formatter = "documentation"
  formatters = config.formatters
  formatters.singleton_class.send(:define_method, :<<) { |*| }
  config.singleton_class.send(:define_method, :formatters) { formatters }
  # config.before(:suite) { system "clear" }
end
