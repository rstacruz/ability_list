require './lib/ability_list/version'

Gem::Specification.new do |s|
  s.name = "ability_list"
  s.version = AbilityList::VERSION
  s.summary = %[Simple user permissions management.]
  s.description = %[A very simple way to manage permissions. Works with any ORM.]
  s.authors = ["Rico Sta. Cruz"]
  s.email = ["hi@ricostacruz.com"]
  s.homepage = "http://github.com/rstacruz/ability_list"
  s.files = `git ls-files`.strip.split("\n")

  s.add_development_dependency "minitest", "> 0"
end
