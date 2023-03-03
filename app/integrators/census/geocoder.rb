# frozen_string_literal: true

module Census
  # Geocode a given address using the API provided by the United States Census Bureau.
  #
  # @see https://geocoding.geo.census.gov/geocoder/Geocoding_Services_API.pdf
  class Geocoder
    include HTTParty
    # debug_output $stdout

    base_uri "https://geocoding.geo.census.gov/geocoder/locations"
    default_params benchmark: "2020", format: "json"
    headers "Content-Type": "application/json"

    def initialize(address)
      @address = address
    end

    # @return [Array] x/y coordinates of given `Address`
    def geocode
      json = JSON.parse(lookup.body)
      match = json.dig("result", "addressMatches").first
      return [] if match.nil?

      coords = match["coordinates"]
      [coords["x"], coords["y"]]
    end

    # Ex:
    #
    # https://geocoding.geo.census.gov/geocoder/locations/address?street=4600+Silver+Hill+Rd&city=%20Washington&state=DC&zip=20233&benchmark=Public_AR_Census2020&format=json
    #
    # @return [json] Raw JSON response from endpoint
    private def lookup
      self.class.get("/address", query: @address.as_json)
    rescue SocketError => err
      Rails.logger.error("Error querying #{self.class.base_uri}:")
      Rails.logger.error(err)
    end
  end
end
