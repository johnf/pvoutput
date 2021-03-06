# PVOutput

[![Actions Status](https://github.com/johnf/pvoutput/workflows/Test/badge.svg)](https://github.com/johnf/pvoutput/actions)
[![Coverage Status](https://coveralls.io/repos/johnf/pvoutput/badge.svg?branch=master&service=github)](https://coveralls.io/github/johnf/pvoutput?branch=master)
[![Gem Version](https://badge.fury.io/rb/pvoutput.svg)](http://badge.fury.io/rb/pvoutput)


Ruby library for talking to the PVOutput API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pvoutput'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pvoutput

## Usage

In order to use pvoutput in your application you need to use

```ruby
require 'pvoutput/client'
```

First step is to create a PVOutput client using your PVOutput assigned system_id and api_key

```ruby
pvoutput = PVOutput::Client.new(system_id, api_key)
```

At the moment you [donate](http://pvoutput.org/donate.jsp) to PVOutput you can enable the donation mode by creating a PVOutput client using

```ruby
pvoutput = PVOutput::Client.new(system_id, api_key, true)
```

Now you can report your real time status to PVOutput using

```ruby
pvoutput.add_status(
  options
)
```

The add_status operation accepts the following options

| Option           | PVOutput Parameter |
| ---------------- | ------------------ |
| energy_generated | v1 |
| power_generated  | v2 |
| energy_consumed  | v3 |
| power_consumed   | v4 |
| temperature      | v5 |
| voltage          | v6 |
| cumulative       | c1 |
| net              | n |

As example

```ruby
client.add_status(
  :energy_generated => 100,
  :power_generated  => 50,
  :temperature      => 30,
  :voltage          => 200,
)
```

You can report your daily output to PVOutput using

```ruby
pvoutput.add_output(
  options
)
```

The add_output operation accepts the following options

| Option                | PVOutput Parameter |
| --------------------- | ------------------ |
| output_date           | d |
| energy_generated      | g |
| peak_power            | pp |
| peak_time             | pt |
| condition             | cd |
| min_temp              | tm |
| max_temp              | tx |
| comments              | cm |
| import_peak           | ip |
| import_off_peak       | io |
| import_shoulder       | is |
| import_high_shoulder  | ih |
| consumption           | c |

As example

```ruby
client.add_output(
  :output_date      => '20160228'
  :energy_generated  => 15000,
  :max_temp      => 30
)
```

You can report also a batch of daily output values to PVOutput using

```ruby
pvoutput.add_batch_output(
  options
)
```

The add_batch_output operation accepts a hash with the date as key and within that the following options

| Option                | PVOutput Parameter |
| --------------------- | ------------------ |
| energy_generated      | g |
| peak_power            | pp |
| peak_time             | pt |
| condition             | cd |
| min_temp              | tm |
| max_temp              | tx |
| comments              | cm |
| import_peak           | ip |
| import_off_peak       | io |
| import_shoulder       | is |
| import_high_shoulder  | ih |
| consumption           | c |

As example

```ruby
client.add_output(
  :'20150101' => {
    :energy_generated => 1239, },
  :'20150102' => {
    :energy_generated => 1523 },
  :'20150103' => {
    :energy_generated => 2190 },
)
```

## Debugging

You can enable HTTParty debugging to see the requests by setting `PVOUTPUT_DEBUG=true`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Release

To release a new version:
  * Create a branch for the release
  * Update the version number in `version.rb`
  * Update CHANGELOG.md
  * git commit -pm 'Release 1.x.x'
  * git tag v1.x.x
  * git push
  * git push --tags
  * In GitHub add the Change Log section to the release and save it
  * Check everything looks OK in GitHub Actions

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/johnf/pvoutput. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

