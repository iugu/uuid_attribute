# UUID::Attribute

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add activerecord-uuid-attribute

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install activerecord-uuid-attribute

## Usage

TODO: Write usage instructions here

```
class YourModel < ApplicationRecord
  # Need to put attribute manually
  attribute :id, :uuid, default: -> { SecureRandom.uuid }
end

UuidAttribute.setup do |config|
  # Configure generators to use UUID as primary key (defaults to true)
  config.default_primary_id = true
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and the created tag, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## TODO

Write tests for each supported rails versions. See examples at:
https://github.com/rails/rails/tree/main/activerecord
https://github.com/heartcombo/simple_form/tree/main/gemfiles

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/pnegri/activerecord-uuid-attribute.

You can connect to discuss at our Discord server: https://discord.gg/nWthPyD7rh