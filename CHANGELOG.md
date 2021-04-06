# Changelog

## Rails Async Migrations v2.0.0

- compatible with Rails 6.0
- tested against Ruby 2.7.2
- default worker changed to Sidekiq

- development can be done within docker
- lint using RuboCop Shopify

## Rails Async Migrations v2.0.1

- compatible with Rails 6.1
- improved the notification message to include markdown
  - migration title is included if the file is found
  - if not in a dev or test environment, a URL to the migration is included
- to generate a URL to the migration, you need to configure the gem with `slack_git_url_mapping_for_envs`. It accepts a hash, for which the keys are the name of the environment and the value is the link to that environment's branch.