spec = Gem::Specification.new do |s|
  s.name = 'config_logic'
  s.version = '0.1.0'

  s.description = %{An intuitive configuration access layer}
  s.summary = 'A configuration access layer for Ruby/Rails applications'
  s.files = Dir['lib/**/*.rb'] + Dir['spec/**/*.rb'] + ["README.rdoc", "TODO"]
  s.require_path = 'lib'
  s.author = "Alex Skryl"
  s.email = "rut216@gmail.com"
  s.homepage = "http://github.com/skryl"

  s.add_dependency(%q<activesupport>, [">= 2.2.2"])
  s.add_dependency(%q<buffered_logger>, [">= 0.1.2"])
end
