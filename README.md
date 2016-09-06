# Backlog Detector

This gem monitors the size of the web server (currently, just Puma) internal request backlog. (The backlog is requests whose socket has been accepted, but which are not yet being processed by the web server.) Once the request backlog exceeds a certain threshold, a flag file is touched. This flag file can be monitored by a fronting web server (e.g. Nginx) to proactively return 503 Service Unavailable, so that the backlog does not grow further. Once the request backlog falls back below the threshold, the flag file is deleted.

The rapid 503 response prevents the backlog from growing without bound, and it prevents the server from trying to process too many requests in parallel. When the server is trying to process too many requests at once, the average latency starts to climb and all clients start to see longer and longer response times.


![Before backlog reporter](./doc/images/before_backlog.png)

![After backlog reporter](./doc/images/after_backlog.png)

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

