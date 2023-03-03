# frozen_string_literal: true

# https://api.weather.gov/points/{latitude},{longitude}
module Nws
  # The NWS API gives weather forecasts for "grids", and the NWS office
  # responsible for that part of the grid. They provide an endpoint that allows
  # for converting lat/long coordinates to these office/x/y values.
  #
  # @see https://www.weather.gov/documentation/services-web-api
  class Points
    include NwsBase

    attr_reader :latitude, :longitude

    def initialize(latitude, longitude)
      @latitude = latitude.round(4)
      @longitude = longitude.round(4)
    end

    # @return [Hash] {gridId: <String>, gridX: <Integer>, gridY: <Integer>}
    def grid
      json = JSON.parse(lookup.body)
      properties = json["properties"]
      {
        gridId: properties["gridId"],
        gridX: properties["gridX"],
        gridY: properties["gridY"],
      }
    end

    # https://api.weather.gov/points/{latitude},{longitude}
    #
    # @return [json] Raw JSON response from endpoint
    private def lookup
      self.class.get("/points/#{latitude},#{longitude}")
    end
  end
end
