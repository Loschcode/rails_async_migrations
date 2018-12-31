# RailsAsyncMigrations

`ActiveRecord::Migration` extension to turn your migrations asynschonous in a simple and straight forward way.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails_async_migrations'
```

And then execute:

    $ bundle

After the gem has been installed, use the generator to add the needed changes

    $ rails generate rails_async_migrations:install

This will add a new migration for the table `async_schema_migrations` which will be used by the gem. You can also add the migration yourself like so:

```
class CreateAsyncSchemaMigrations < ActiveRecord::Migration[5.2]
  def change
    create_table :async_schema_migrations do |t|
      t.string :version
      t.string :direction
      t.string :state

      t.timestamps
    end
  end
end
```

## Usage

To turn some of your migrations asynchronous, just use the `turn_async` keyword.

```
class Test < ActiveRecord::Migration[5.2]
  turn_async

  def change
    create_table 'tests' do |t|
      t.string :test
    end
  end
end
```

Now when you'll run the migration it'll simply run the migrations in queue as it would usually do, but the content of `#change` will be taken away and executed into an asynchronous queue.

What is turned asynchronous will be executed exactly the same way as a classical migration, which means you can use all keywords of the classic `ActiveRecord::Migration` such as `create_table`, `add_column`, etc.

Each migration which is turned asynchronous will follow each other, once one the first migration of the queue is ended without problem, it pass to the next one. If it fails, the error will be raised within the worker so it retries until it works, or until it's considered dead.

You can also manually launch the queue check and fire by using:

    $ rake rails_async_migrations:check_queue

**For now, there is no rollback mechanism authorized, even if the source code is pratically for it, it complexifies the logic and may not be needed.**

## States

| State          | Description                                                                                                                  |
| -------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| **created**    | the migration has just been added through the classical migration queue                                                      |
| **pending**    | the migration has been spotted by the asynchronous queue and will be processed                                               |
| **processing** | the migration is being processed right now                                                                                   |
| **done**       | the migration was successful                                                                                                 |
| **failed**     | the migration failed while being processed, there may be other attempts to make it pass depending your workers configuration |

## Motives

This library was made with the intent to help startups which are struggling to scale. Small projects don't need asynchronous migrations queues, and big companies build their own parallel systems when facing scaling problems, but what about medium sized companies with limited resources ?

When a project grows, your database start to be heavy and changing the data through the deployment process can be very painful. Most people turn heavy data changes into `rake tasks` ; there's two school of thought about this.

1. Migrations should only mutate database structures and not its data, and other things should be processed via other means.
2. Migrations are everything which alter data one time, typicall during a deployment of new code.

Turning data changes into a `rake task` can be a good idea, and it's ideal to test it out too, but sometimes you need this fat ass loop which will be ran once, and only once and making a `rake task` for that it's overkill. This gem is here to answer to this need.

## Workers

For now, the system works slowly coupled with Sidekiq. If you use other technologies, please hit me up and I'll create additional adapters for you.

## Compatibility

The gem has been tested and is working with `ActiveRecord 5.2.2`, if you want it compatible with earlier versions, please hit me up.

## Development

I created this library as my company was struggling in its deployment process. It lacks functionalities but this is a good starting point ; everything is easily extendable so don't hesitate to add your own needed methods to it.

You're more than welcome to open an issue with feature requests so I can work on improving this library.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/rails_async_migrations/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Author

[Laurent Schaffner](http://www.laurentschaffner.com)

## License

MIT License.

## Changelog
