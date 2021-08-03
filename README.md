# Archer

Rails console history for Heroku, Docker, and more

![Screenshot](https://ankane.org/images/archer-readme.png)

Designed for platforms with ephemeral filesystems

## Installation

Add this line to your application’s Gemfile:

```ruby
gem 'archer-rails'
```

And run:

```sh
rails generate archer:install
rails db:migrate
```

Lastly, update your Gemfile to only include it in environments where you need it:

```ruby
gem 'archer-rails', group: [:production]
```

## How It Works

Ruby stores console history in a file specified by:

```ruby
IRB.conf[:HISTORY_FILE]
```

This file gets lost on ephemeral filesystems. Instead, we store its contents in the database.

## Users

Each user can keep their own history. The user determined by `ENV["USER"]` by default. You can specify a user when starting the console with:

```sh
USER=andrew rails console
```

Confirm it worked with:

```rb
Archer.user
```

## Clearing History

Disable saving history for the current session with:

```ruby
Archer.save_session = false
```

You should do this when running sensitive commands.

Clear history for current user with:

```ruby
Archer.clear
```

## Configuration

Change the number of commands to remember

```ruby
Archer.limit = 200 # default
```

Change how the user is determined

```ruby
Archer.user = ENV["USER"] # default
```

## Platform Notes

### Heroku

For user-specific history, the command should follow this format:

```sh
heroku run USER=andrew rails console
```

Set up an [alias](https://shapeshed.com/unix-alias/) to save yourself some typing

```sh
alias hc="heroku run USER=andrew rails console"
```

### Dokku

There’s no way to specify a user at the moment.

## History

View the [changelog](https://github.com/ankane/archer/blob/master/CHANGELOG.md)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/archer/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/archer/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

To get started with development:

```sh
git clone https://github.com/ankane/archer.git
cd archer
bundle install
```
