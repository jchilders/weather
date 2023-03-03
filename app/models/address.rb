# frozen_string_literal: true

class Address
  extend Dry::Initializer[undefined: false]

  option :street, optional: false
  option :city, optional: true
  option :state, optional: true
  option :zip, optional: false

  # This is an asynchronous operation.
  def geocode
    Census::Geocoder.new(self).geocode
  end
end
