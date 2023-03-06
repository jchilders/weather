# README

## About

This is a Ruby on Rails application that can get the current weather conditions for a user-supplied location, as well as the weather forecast. It does this by querying endpoints provided by the United States Census Bureau and the National Weather Service.

Styling is done using Tailwind CSS.

## Installation

```
brew install postgresql@14
brew services start postgresql
bundle install
```

## Running

```
bin/dev
```

After starting the application will be available at [http://localhost:3000](http://localhost:3000).

## Enabling caching

```
bin/rails dev:cache
```

Weather data is cached for 30 minutes on a per-zip code basis. See [ForecastController#show](https://github.com/jchilders/weather/blob/main/app/controllers/forecasts_controller.rb#L7).

## Running tests

```
rspec
```

## Code linting

Uses [Shopify's Style Guide](https://ruby-style-guide.shopify.dev/) as the basis for code styling.

```
rubocop
```

## Service Objects

The API calls are done using [HTTParty](https://github.com/jnunemaker/httparty) and [dry-transaction](https://dry-rb.org/gems/dry-transaction). HTTParty provides helpers for making the HTTP calls, while dry-transaction provides a framework for doing [railway oriented programming](https://www.youtube.com/watch?v=YXiqzHMmv_o).

Each API call is wrapped in a transaction. For example, the class which translates an address to geocoordinates is `Census::Geocoder`. Currently, it looks something like this:

```ruby
  class Geocoder
    include ExternalApi

    base_uri "https://geocoding.geo.census.gov/geocoder/locations"
    default_params benchmark: "2020", format: "json"
    headers "Content-Type": "application/json"

    try :lookup, catch: SocketError
    try :parse, catch: JSON::JSONError
    step :geocoder

    # ... snip ....
  end
```

The `base_uri`, `default_params`, and `headers` calls are provided by HTTParty and are fairly self-explanatory. The `try` and `step` methods are provided by `dry-transaction` and are where the work needed for this specific transaction gets done. Each of these methods will, typically implicitly, return a `Dry::Monads::Result` object. If any of these methods return a failure then no further steps are performed, and the failure is returned.
