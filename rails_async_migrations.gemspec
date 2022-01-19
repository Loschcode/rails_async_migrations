lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_async_migrations/version'

Gem::Specification.new do |spec|
  spec.name          = 'rails_async_migrations'
  spec.version       = RailsAsyncMigrations::VERSION
  spec.authors       = ['Laurent Schaffner']
  spec.email         = ['laurent.schaffner.code@gmail.com']

  spec.summary       = 'Asynchronous support for ActiveRecord::Migration'
  spec.homepage      = 'https://www.laurent.tech'
  spec.license       = 'MIT'

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'pry', '~> 0.12'
  spec.add_development_dependency 'rails', '~> 6.1'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'rspec-sidekiq'
end
