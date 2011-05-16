# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "maps/version"

Gem::Specification.new do |s|
  s.name        = "maps"
  s.version     = Maps::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Caio Lopes"]
  s.email       = ["caio.lopes@i.ndigo.com.br"]
  s.homepage    = ""
  s.summary     = %q{maps gem}
  s.description = %q{google maps test}

  s.rubyforge_project = "maps"
  s.add_dependency('mongoid', '2.0.0.rc.6')
  s.add_dependency('bson_ext', '>=1.2')
  s.add_dependency('geokit', '1.5.0')
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
