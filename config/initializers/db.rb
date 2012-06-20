Dir.glob(File.join('lib', 'models', '*.rb')).each do |file|
  require_relative File.join("..", "..", file)
end