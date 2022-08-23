# UUidAttribute

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add uuid_attribute

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install uuid_attribute

## Usage

```
class YourModel < ApplicationRecord
end

model = YourModel.create( ... )
YourModel:0x00007f85774135a8  
 id: "5iLEaLFZUeD6Dg8nnfSiCZ",
... > 

Or if you want to disable auto detect of UUIDs

UuidAttribute.setup do |config|
  # Configure generators to use UUID as primary key (defaults to true)
  config.auto_detect_binary_ids = false
end

class YourModel < ApplicationRecord
  attribute :id, :uuid, default: -> { SecureRandom.uuid }
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and the created tag, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/pnegri/activerecord-uuid-attribute.

You can connect to discuss at our Discord server: https://discord.gg/nWthPyD7rh