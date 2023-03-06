# frozen_string_literal: true

# Get current/high/low temperatures for given `office`, `grid_x`, and `grid_y`.
#
# @see `Nws::Points` for getting this data for a given set of geocoordinates.
#
# Ex:
# https://api.weather.gov/gridpoints/TOP/31,80/forecast
module Nws
  class Temperatures
    include NwsBase

    try :lookup, catch: SocketError
    step :response_ok?
    try :parse, catch: JSON::JSONError
    map :temperatures

    # @return [Hash]
    private def lookup(grid_id:, grid_x:, grid_y:, **)
      self.class.get("/gridpoints/#{grid_id}/#{grid_x},#{grid_y}")
    end

    private def response_ok?(response)
      response.ok? ? Success(response) : Failure(response)
    end

    # @return [Hash]
    private def parse(response)
      JSON.parse(response.body).deep_symbolize_keys!
    end

    # @return [Hash] { temperature:current: 82, temperature_high: 90, temperature_low: 80 }
    private def temperatures(json)
      props = json[:properties]

      curr_temp = c_to_f(props[:temperature][:values].last[:value])
      high_temp = c_to_f(props[:maxTemperature][:values][0][:value])
      low_temp = c_to_f(props[:minTemperature][:values][0][:value])
      {
        temperature_current: curr_temp,
        temperature_high: high_temp,
        temperature_low: low_temp,
      }
    end

    # @return [Integer]
    private def c_to_f(temperature)
      ((temperature * 9 / 5) + 32).to_i
    end
  end
end
