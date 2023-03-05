# frozen_string_literal: true

module Census
  # Geocode a given `Address` using the API provided by the United States
  # Census Bureau.
  #
  # Ex call:
  #
  # > addr = Address.new(street: "1234 Main Rd", zip: "99999")
  # > Census::Geocoder.new.call(addr)
  # => Success({ latitude: 35.1234, longitude: 95.5678 })
  #
  # @see https://geocoding.geo.census.gov/geocoder/Geocoding_Services_API.pdf
  class Geocoder
    include Dry::Transaction
    include ExternalApi

    base_uri "https://geocoding.geo.census.gov/geocoder/locations"
    default_params benchmark: "2020", format: "json"
    headers "Content-Type": "application/json"

    try :lookup, catch: SocketError
    try :parse, catch: JSON::JSONError
    step :geocode

    # Call the Census Bureau API endpoint with the given `address`
    #
    # @param [Address]
    #
    # @return [Success(HTTParty::Response)] On success
    # @return [Failure(SocketError)] On network failure
    private def lookup(address)
      self.class.get("/address", query: address.as_json)
    end

    # @param [HTTParty::Response]
    private def parse(response)
      JSON.parse(response.body)
    end

    # @return [Result[Array]] latitude/longitude coordinates of given `json`
    # response
    private def geocode(json)
      matches = json.dig("result", "addressMatches")
      return Failure("No matching addresses") if matches.blank?

      match = matches.first
      coords = match["coordinates"]
      Success({
        latitude: coords["y"],
        longitude: coords["x"],
      })
    end
  end
end
