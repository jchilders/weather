# frozen_string_literal: true

# Get forecast data for given `office`, `grid_x`, and `grid_y`.
#
# @see `Nws::Points` to get above data for a given set of geocoordinates.
#
# Ex:
# https://api.weather.gov/gridpoints/TOP/31,80/forecast
module Nws
  class Forecast
    include HTTParty
    # debug_output $stdout

    base_uri "https://api.weather.gov/"
    headers "User-Agent": "(test weather app, james.childers@gmail.com)"
  end
end
