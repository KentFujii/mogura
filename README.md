# Mogura

Digdag REST API and Ruby language API bridge for Rails.

## Project Focus

https://dev.to/kentfujii/ive-created-a-tiny-library-connecting-rails-and-digdag-42d2

## Installation

Add this line to your Rails application's Gemfile:

```ruby
gem 'mogura'
```

And then execute:

```
$ bundle install
```

## Usage

```ruby
# config/initializers/mogura.rb
Mogura.configure do |config|
  config.endpoint = 'http://digdag:65432'
end
```

```ruby
# lib/taksks/mogura.rake
namespace :mogura do
  desc "create or update project"
  task :push, [:project] => :environment do |_, args|
    sample_dag = Mogura::Builder::Dag.build(
      name: 'sample_dag',
      tasks: {
        "timezone": "Asia/Tokyo",
        "schedule": {
          "minutes_interval>": "1"
        },
        "+say_hello": {
          "echo>": "Hello world!!!!"
        }
      }
    )
    Mogura::Project::Put.project(project: args.project, dags: [sample_dag])
  end

  desc "delete project"
  task :delete, [:project_id] => :environment do |_, args|
    Mogura::Project::Delete.project(id: args.project_id)
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/mogura. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/mogura/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Mogura project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/mogura/blob/master/CODE_OF_CONDUCT.md).
