# Changelog

## v2.0.4

- format execution time if possible
- update dependencies
- lint
- test against multiple versions of Ruby with Rails 7

## v2.0.3

- new config option: `disable_async_migrations` to disable async migrations

## v2.0.2

- `slack_git_url_mapping_for_envs` has become `slack_git_url`, and now accepts only a single URL
## v2.0.1

- compatible with Rails 6.1
- improved the notification message to include markdown
  - migration title is included if the file is found
  - if not in a dev or test environment, a URL to the migration is included
- to generate a URL to the migration, you need to configure the gem with `slack_git_url_mapping_for_envs`. It accepts a hash, for which the keys are the name of the environment and the value is the link to that environment's branch.
## v2.0.0

- compatible with Rails 6.0
- tested against Ruby 2.7.2
- default worker changed to Sidekiq

- development can be done within docker
- lint using RuboCop Shopify