path = File.expand_path("../../", __FILE__)

ENV['ENV'] = 'test'
require "#{path}/config/initializers/environment.rb"

RSpec.configure do |c|
  c.mock_with :rspec
end