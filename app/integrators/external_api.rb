# frozen_string_literal: true

module ExternalApi
  class << self
    def included(base)
      base.class_eval do
        include(Dry::Transaction)
        include(HTTParty)
      end
    end
  end
end
