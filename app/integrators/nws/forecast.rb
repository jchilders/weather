# frozen_string_literal: true

# Get forecast data for given `office`, `grid_x`, and `grid_y`.
#
# @see `Nws::Points` for getting this data for a given set of geocoordinates.
#
# Ex:
# https://api.weather.gov/gridpoints/TOP/31,80/forecast
module Nws
  class Forecast
    include NwsBase

    param(:gridId)
    param(:gridX)
    param(:gridY)

    # @return [Hash]
    def call
      resp = self.class.get("/gridpoints/#{gridid}/#{gridx},#{gridy}/forecast")
      JSON.parse(resp.body)
    end
  end
end
