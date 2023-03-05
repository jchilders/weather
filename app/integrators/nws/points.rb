# frozen_string_literal: true

module Nws
  # The NWS API gives weather forecasts for "grids", and the NWS office
  # responsible for that part of the grid. They provide an endpoint that allows
  # for converting lat/long coordinates to these office/x/y values.
  #
  # This class converts geocordinates to this grid format.
  #
  # @see https://www.weather.gov/documentation/services-web-api
  class Points
    include NwsBase

    try :lookup, catch: SocketError
    try :to_grid, catch: JSON::JSONError

    # https://api.weather.gov/points/{latitude},{longitude}
    #
    # @return [json] Raw JSON response from endpoint
    private def lookup(latitude:, longitude:)
      self.class.get("/points/#{latitude},#{longitude}")
    end

    # @param [HTTParty::Response]
    #
    # @return [Success(Hash)] {gridId: <String>, gridX: <Integer>, gridY: <Integer>}
    private def to_grid(response)
      json = JSON.parse(response.body)
      properties = json["properties"]
      {
        grid_id: properties["gridId"],
        grid_x: properties["gridX"],
        grid_y: properties["gridY"],
      }
    end
  end
end
