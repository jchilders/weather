# frozen_string_literal: true

module Census
  # Geocode a given address using the API provided by the United States Census Bureau.
  #
  # Ex call:
  #
  # > addr = Address.new(street: "1234 Main Rd", zip: "99999")
  # > Census::Geocoder.new.call(addr)
  # => Success([35.1234, 95.5678])
  #
  # @see https://geocoding.geo.census.gov/geocoder/Geocoding_Services_API.pdf
  class Geocoder
    include Dry::Transaction
    include ExternalApi

    base_uri "https://geocoding.geo.census.gov/geocoder/locations"
    default_params benchmark: "2020", format: "json"
    headers "Content-Type": "application/json"

    NORTH_POLE = [90, 0].freeze

    step :lookup
    step :geocode

    # Ex:
    #
    # https://geocoding.geo.census.gov/geocoder/locations/address?street=4600+Silver+Hill+Rd&city=%20Washington&state=DC&zip=20233&benchmark=Public_AR_Census2020&format=json
    #
    # @return [Result[Hash]] On success
    # @return [Result[SocketError]] On network failure
    private def lookup(address)
      resp = self.class.get("/address", query: address.as_json)
      Success(JSON.parse(resp.body))
    rescue SocketError => err
      Rails.logger.error("Error querying #{self.class.base_uri}:")
      Rails.logger.error(err)
      Failure(err)
    end

    # @return [Result[Array]] latitude/longitude coordinates of given `json`
    # response
    private def geocode(json)
      matches = json.dig("result", "addressMatches")
      return Failure(NORTH_POLE) if matches.blank?

      match = matches.first
      return Failure(NORTH_POLE) if match.nil?

      coords = match["coordinates"]
      Success([coords["y"], coords["x"]]) # yeah, they're kinda backwards
    end
  end
end
