# PumaBacklogDetector

Periodically checks Puma backlog and creates a flag file if too high.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'puma_backlog_detector'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install puma_backlog_detector

## Usage

In rails config:

```ruby
  config.puma_backlog_detector.flag_path = '/run/app/congested.flag'
  config.puma_backlog_detector.max_backlog = 16
  config.puma_backlog_detector.check_interval = 0.01 # seconds
```

In nginx config:

```
  location / {
    proxy_pass http://localhost:300;

    if (-f /run/app/congested.flag) {
      return 503;
    }
  }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dividedmind/puma_backlog_detector.

