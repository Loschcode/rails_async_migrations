# frozen_string_literal: true
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rails_async_migrations/version"

Gem::Specification.new do |spec|
  spec.name          = "rails_async_migrations"
  spec.version       = RailsAsyncMigrations::VERSION
  spec.authors       = ["Laurent Schaffner", "Pierre Jolivet", "Sean Floyd"]
  spec.email         = ["laurent.schaffner.code@gmail.com", "pierre@hivebrite.com", "sean@hivebrite.com"]

  spec.summary       = "Asynchronous support for ActiveRecord::Migration"
  spec.homepage      = "https://github.com/Hivebrite/rails_async_migrations"
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path("..", __FILE__)) do
    %x(git ls-files -z).split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency("debug", "~> 1.4")
  spec.add_development_dependency("rubocop-shopify")
  spec.add_development_dependency("rails", ">= 6.1")
  spec.add_development_dependency("rake", ">= 13")
  spec.add_development_dependency("sqlite3", ">= 1.4.2")
  spec.add_development_dependency("rspec", ">= 3.10")
  spec.add_development_dependency("database_cleaner", ">= 2.0")
  spec.add_development_dependency("rspec-sidekiq", ">= 3.1")
  spec.add_development_dependency("shoulda-matchers", ">= 5")
  spec.add_development_dependency("fantaskspec", ">= 1.2")

  spec.add_runtime_dependency("activerecord", ">= 6.1")
  spec.add_runtime_dependency("sidekiq", ">= 6.2")
  spec.add_runtime_dependency("delayed_job_active_record", ">= 4.1")
  spec.add_runtime_dependency("slack-notifier", ">= 2.3")
end
