# RailsAsyncMigrations

`ActiveRecord::Migration` extension to turn your migrations asynschonous in a simple and straight forward way.

## Motives

This library was made with the intent to help small companies which are struggling to scale at technical level. Small projects don't need asynchronous migrations queues, and big companies build their own parallel systems when facing scaling problems, but what about medium sized companies with limited resources ?

When a project grows, your database starts to be heavy and changing the data through the deployment process can be very painful. There are numerous reasons you want this process to be [at least] partially asynchronous.

Most people turn heavy data changes into `rake tasks` or split workers; there are two schools of thought about this.

1. Migrations should only mutate database structures and not its data, and if it's the case, it should be split and processed via other means.
2. Migrations are everything which alter data one time, typically during a deployment of new code and structure.

Turning data changes into a `rake task` can be a good idea, and it's ideal to test it out too, but sometimes you need this **fat ass loop** of **>1,000,000 records** which will be run **once, and only once** to be run fast and without locking down the deployment process itself; making a `rake task` for that is overkill. After all, it will only be used once and within a specific structure / data context. This gem is here to answer this need.

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

To turn some of your migrations asynchronous, generate a migration as you would normally do and use the `turn_async` keyword.

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

From now on, when you run this migration it'll simply run the normal queue, but the content of `#change` will be taken away and later on executed into an asynchronous queue.

What is turned asynchronous is executed exactly the same way as a classical migration, which means you can use all keywords of the classic `ActiveRecord::Migration` such as `create_table`, `add_column`, etc.

## Configuration

**No configuration is needed to start using this library**, but some options are given to adapt to your needs.

Add the following lines into your `config/initializer/` folder

```
RailsAsyncMigrations.config do |config|
  # `:verbose` can be used if you want a full log of the execution
  config.mode = :quiet

  # when the migration is turned asynchronous
  # it watches over some specific `ActiveRecord` methods
  # by adding them to this array, you'll lock and turn those methods asynchronous
  # by removing them you'll let them use the classical migration process
  # for example, if you set the `locked_methods` to %i[async] the migration will be processed normally
  # but the content of the `#async` method will be taken away and executed within the asynchronous queue
  config.locked_methods =  %i[change up down]
end
```

## Queue

Each migration which is turned asynchronous follows each other, once one migration of the queue is ended without problem, it passes to the next one.

If it fails, the error will be raised within the worker so it retries until it eventually works, or until it's considered dead. None of the further asynchronous migrations will be run until you fix the failed one, which is a good protection for data consistency.

You can also manually launch the queue check and fire by using:

    $ rake rails_async_migrations:check_queue

**For now, there is no rollback mechanism authorized, even if the source code is ready for it, it complexifies the build up logic and may not be needed in asynchronous cases.**

## States

| State          | Description                                                                                                                  |
| -------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| **created**    | the migration has just been added through the classical migration queue                                                      |
| **pending**    | the migration has been spotted by the asynchronous queue and will be processed                                               |
| **processing** | the migration is being processed right now                                                                                   |
| **done**       | the migration was successful                                                                                                 |
| **failed**     | the migration failed while being processed, there may be other attempts to make it pass depending your workers configuration |

## Failure handling

If your migration crashes, and blocks the rest of your asynchronous migrations but you want to execute the rest anyway, you can change the code of the migration file and push it again so it passes, or simply remove / update as `state = done` the matching `async_schema_migrations` row.

The `version` value is always the same as the classic migrations ones.

## Requirements

⚠ For now, the workers are coupled with Sidekiq. If you use other technologies, please hit me up and I'll create additional adapters for you.

## Compatibility

The gem has been tested and is working with `ActiveRecord 5.2.2`, if you want it compatible with earlier versions, please hit me up.

## Development

I created this library as my company was struggling in its deployment process. It lacks functionalities but this is a good starting point; everything is easily extendable so don't hesitate to add your own needed methods to it.

You're more than welcome to open an issue with feature requests so I can work on improving this library.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/rails_async_migrations/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Author

[Laurent Schaffner](http://www.laurentschaffner.com)

## Credits

This project and its idea was inspired by [Kir Shatrov article](https://kirshatrov.com/2018/04/01/async-migrations/) on the matter, it's worth a look!

## License

MIT License.

## Changelog
