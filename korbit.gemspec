$:.push File.expand_path("../lib", __FILE__)

require "korbit/client/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "korbit"
  s.version     = Korbit::Client::VERSION
  s.authors     = ["Peatio Opensource"]
  s.email       = ["community@peatio.com"]
  s.homepage    = "https://github.com/begaborn/korbit"
  s.summary     = "A ruby client to access Korbit's API."
  s.description = "A ruby client which can access all Korbit's API."
  s.license     = 'MIT'

  #s.executables = ['pcurl']
  s.files       = Dir["{bin,lib}/**/*"] + ["README.md"]

  s.add_dependency 'activesupport', '~> 5.1.4'
end
