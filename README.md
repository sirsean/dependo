# Dependo

Dependo is a very simple Dependency Injection framework for Ruby. Some say [you don't need dependency injection](http://weblog.jamisbuck.org/2008/11/9/legos-play-doh-and-programming) when you're using Ruby. Maybe they're right, but I've come across some places where I need it.

For example, in my apps using Sinatra and Sequel, I need to be able to log, using a single Logger instance, from both my Sinatra app and from within my Sequel models. I'm not about to pass that Logger around as a parameter anywhere, and I don't want to instantiate it in every class that needs to log.

So, injecting the Logger is the easiest, best solution.

## Requirements/Installation

Dependo doesn't depend on anything. In test, it relies on rspec and either rcov (Ruby 1.8) or simplecov (Ruby 1.9).

Install the gem: ```gem install dependo-(version).gem```

## Running the tests:

```rake spec```

## Building the gem:

```rake gem:build```

## Install gem with Rake:

```rake gem:install```

## Usage

### Register

```ruby
Dependo::Registry[:log] = Logger.new(STDOUT)
```

### Include

This makes it easy to use your injected dependencies as instance methods:

```ruby
class MyThing
    include Dependo::Mixin
end

thing = MyThing.new
thing.log.info "I'm logging!"
```

### Extend

This makes it easy to use your injected dependencies as class methods:

```ruby
class MyThing
    extend Dependo::Mixin
end

MyThing.log.info "I'm logging!"
```

##License

See the LICENSE file. Licensed under the Apache 2.0 License
