ENV["SUITE"] = "features" if ARGV.any? { |arg| arg.include?("_feature_spec.rb") }

RSpec.configure do |config|
  config.reset
  if ENV["SUITE"] != "features"
    config.formatter = "documentation"
    formatters = config.formatters
    formatters.singleton_class.send(:define_method, :<<) { |*| }
    config.singleton_class.send(:define_method, :formatters) { formatters }
  end
end
