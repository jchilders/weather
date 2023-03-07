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
    check :response_ok?
    try :parse, catch: JSON::JSONError
    map :forecast

    default_params units: "us" # only works on this endpoint, apparently

    # @return [Hash]
    private def lookup(grid_id:, grid_x:, grid_y:, **)
      self.class.get("/gridpoints/#{grid_id}/#{grid_y},#{grid_y}/forecast")
    end

    # @return [Result[Array[Hash]]]
    private def forecast(json)
      props = json[:properties]
      props[:periods]
    end
  end
end
