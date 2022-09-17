# Mogura

Digdag REST API and Ruby language API bridge for Rails.

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

### CLI

```
$ bundle exec mogura help
Commands:
  mogura help [COMMAND]  # Describe available commands or one specific command
  mogura init            # Initialize Digdag files
  mogura push            # Push Digdag workflows
  mogura version         # Prints version
```

### Rails

```ruby
# config/initializers/mogura.rb
Mogura.configure do |config|
  config.endpoint = 'http://digdag:65432'
end
```

```ruby
# lib/taksks/mogura.rake
namespace :mogura do
  desc "push"
  task :push, [:project] => :environment do |_, args|
    Mogura::Push.push(endpoint: args.project)
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
