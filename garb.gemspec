# -*- encoding: utf-8 -*-
require File.expand_path('../lib/garb/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Tony Pitale', 'Sijawusz Pur Rahnama', 'Lukas Hodel']
  gem.email         = ['tony.pitale@viget.com', 'sija@sija.pl', 'l.hodel@de.edenspiekermann.com']
  gem.homepage      = 'http://github.com/codingluke/garb'

  gem.summary       = 'Google Analytics API Ruby Wrapper'
  gem.description   = ''

  gem.files         = `git ls-files`.split $\
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'garb'
  gem.require_paths = ['lib']
  gem.version       = Garb::VERSION

  gem.add_dependency 'activesupport', '>= 2.2'
  gem.add_dependency 'multi_json', '>= 1.3'
  gem.add_dependency 'em-synchrony'
  gem.add_dependency 'em-http-request'
end
