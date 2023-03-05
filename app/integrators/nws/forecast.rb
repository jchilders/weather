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

    try :lookup, catch: SocketError

    # @return [Hash]
    private def lookup(grid_id:, grid_x:, grid_y:)
      resp = self.class.get("/gridpoints/#{grid_id}/#{grid_y},#{grid_y}/forecast")
      JSON.parse(resp.body)
    end
  end
end
