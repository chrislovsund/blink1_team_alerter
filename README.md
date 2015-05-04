# Blink1TeamAlerter

Help the team spot important situations by using blink1 to visualize events like important JIRA issue.

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/blink1_team_alerter`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'blink1_team_alerter'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install blink1_team_alerter

## Prepare the Machine
Install needed packages:

```sudo dnf install -y libusb-devel```

Clone the blink(1) code repo:

```git clone git://github.com/todbot/blink1.git```

Compile the blink(1) binaries:

```cd blink1/commandline/ && make```

Modify your udev rules so non-root users can access the device. You may need to replug the device after this step:

```cd blink1/linux/ && sudo cp ./51-blink1.rules /etc/udev/rules.d/ && sudo udevadm control --reload-rules```

## Usage

To check JIRA for prio 0 issues and turn on blink1 run:

```bin/check_jira -u<USERNAME> -p<PASSWORD> -h<HOST> -k<PROJECT_KEY>```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/chrislovsund/blink1_team_alerter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
