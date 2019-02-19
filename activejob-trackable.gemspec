# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'activejob/trackable/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'activejob-trackable'
  spec.version     = ActiveJob::Trackable::VERSION
  spec.authors     = ['Ignatius Reza']
  spec.email       = ['lyoneil.de.sire@gmail.com']
  spec.homepage    = 'https://github.com/ignatiusreza/activejob-trackable'
  spec.summary     = 'Extend ActiveJob with the ability to track (debounce, throttle) jobs'
  spec.description = 'Get more control into your jobs with the ability to track (debounce, throttle) jobs'
  spec.license     = 'MIT'

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'rails', '~> 5.2.2'

  spec.add_development_dependency 'minitest-ci'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'sqlite3', '~> 1.3.6'
end
