# RailsAsyncMigrations

`ActiveRecord::Migration` extension to turn your migrations asynschonous in a simple and straight forward way.

## Motives

This library was made with the intent to help small companies which are struggling to scale at technical level. Small projects don't need asynchronous migrations queues, and big companies build their own parallel systems when facing scaling problems, but what about medium sized companies with limited resources ?

When a project grows, your database starts to be heavy and changing the data through the deployment process can be very painful. There are numerous reasons you want this process to be [at least] partially asynchronous.

Most people turn heavy data changes into `rake tasks` or split workers; there are two schools of thought about this.

1. Migrations should only mutate database structures and not its data, and if it's the case, it should be split and processed via other means.
2. Migrations are everything which alter data one time, typically during a deployment of new code and structure.

Turning data changes into a `rake task` can be a good idea, and it's ideal to test it out too, but sometimes you need this **fat ass loop** of **>10,000,000 records** which will be run **once, and only once** with complicated conditions to be run fast and without locking down the deployment process itself; making a `rake task` for that is overkill. After all, it will only be used once and within a specific structure / data context. This gem is here to answer this need.

Some would argue there's also `rake db:seed` for that, which I agree with. The advantage over this methodology is to be able to split in different steps the updating process and have more flow control. By using this gem you can monitor the different completed changes while they are being run, because it uses the same philosophy than step-by-step migrations. Seeding data in term of flow process isn't so different from migrating a database structure, that's why so many people hack it this way (directly within the migrations).

## Warning

Migrating your data isn't easy and this gem isn't some magical technology. Putting some of your migration logic into a parallel asynchronous queue has consequences. Be careful about what you turn asynchronous:

- Does it have any relation with what's run synchronously ?
- Should I configure my workers to repeat the migration, or kill it after one full attempt ?
- Is there a risk of crash of my synchronous migration ? If so, should I let the asynchronous being spawned before safety is ensured ?
- Should I use ActiveRecord::Migration functionalities (especially DDL transactions) or use it in parallel to keep a safety net on worker idempotency ?

This is all up to you, but be aware this solves some problems, but makes you think of the different strategies you should adopt, depending your project.

**Your asynchronous migrations should be written being aware it'll be run on a parallel daemon which can crash, restart and try things again**

## Requirements

You can use this library through different background processing technologies

| Type             | Version | Documentation                                 | Default |
| ---------------- | ------- | --------------------------------------------- | ------- |
| **Sidekiq**      | 5.2.3   | https://github.com/mperham/sidekiq            | NO      |
| **Delayed::Job** | 4.1.3   | https://github.com/collectiveidea/delayed_job | YES     |

Please install and configure one of those before to use this gem. If you use other libraries to setup your workers, please hit me up and I'll create additional adapters for you.

This gem has been tested and is working with `ActiveRecord 5.2.2`, if you notice abnormal behavior with other versions or want it compatible with earlier versions, please hit me up.

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
    # data update logic you would put into a worker here
  end
end
```

From now on, when you run this migration it'll simply run the normal queue, but the content of `#change` will be taken away and later on executed into an asynchronous queue.

What is turned asynchronous is executed exactly the same way as a classical migration, which means you can use all keywords of the classic `ActiveRecord::Migration` such as `create_table`, `add_column`, ...

**It does not mean you should use them like you would in a synchronous migration.** To avoid data inconsistency, be careful about idempotency which's a natural side effect of using workers; add up conditions to make it reliable.

## Configuration

**No configuration is needed to start using this library**, but some options are given to adapt to your needs.

Add the following lines into your `config/initializer/` folder

```
RailsAsyncMigrations.config do |config|
  # :verbose can be used if you want a full log of the execution
  config.mode = :quiet

  # which adapter worker you want to use for this library
  # for now you have two options: :delayed_job or :sidekiq
  config.workers = :sidekiq

  # sidekiq queue name to use for async migrations
  config.sidekiq_queue = :custom_queue
end
```

## Queue

Each migration which is turned asynchronous follows each other, once one migration of the queue is ended without problem, it passes to the next one.

If it fails, the error will be raised within the worker so it retries until it eventually works, or until it's considered dead. None of the further asynchronous migrations will be run until you fix the failed one, which is a good protection for data consistency.

![RailsAsyncMigrations Schema](https://cdn-images-1.medium.com/max/1600/1*VklEFF8IWnmMI6-Cq20nVA.png "RailsAsyncMigrations Schema")

You can also manually launch the queue check and fire by using:

    $ rake rails_async_migrations:check_queue

**For now, there is no rollback mechanism authorized. It means if you rollback the asynchronous migrations will be simply ignored. Handling multiple directions complexifies the build up logic and may not be needed in asynchronous cases.**

## States

| State          | Description                                                                                                                  |
| -------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| **created**    | the migration has just been added through the classical migration queue                                                      |
| **pending**    | the migration has been spotted by the asynchronous queue and will be processed                                               |
| **processing** | the migration is being processed right now                                                                                   |
| **done**       | the migration was successful                                                                                                 |
| **failed**     | the migration failed while being processed, there may be other attempts to make it pass depending your workers configuration |

## Failure handling

If your migration crashes, and blocks the rest of your queue but you want to execute them anyway, you can use multiple strategies to do so:

- Change the code of the migration file and push it again so it passes
- Remove the matching row in the `async_schema_migrations` table. In this case, if you `rollback` your migration and run them again, it'll be newly added to the rows
- Update the matching row with `async_schema_migrations.state = done`. It'll be considered processed and won't ever be tried again.

To find the matching migration, be aware the `version` value is always the same as the classic migrations ones, so it's pretty easy to find things around.

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

## Articles

[How to turn my ActiveRecord migrations asynchronous ?](https://medium.com/@LoschCode/how-to-turn-my-activerecord-migrations-asynchronous-c160b599f38)

## License

MIT License.
