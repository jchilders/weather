# frozen_string_literal: true

require "dry-types"

class Address
  extend Dry::Initializer[undefined: false]

  option(:street, optional: false, type: Dry::Types["strict.string"])
  option(:city, optional: true, type: Dry::Types["strict.string"])
  option(:state, optional: true, type: Dry::Types["strict.string"])
  option(:zip, optional: false, type: Dry::Types["coercible.integer"])
end
