# frozen_string_literal: true

module Nws
  # @see https://www.weather.gov/documentation/services-web-api
  module NwsBase
    class << self
      def included(base)
        base.class_eval do
          include(ExternalApi)

          base_uri("https://api.weather.gov")
          headers("User-Agent": "(test weather app, james.childers@gmail.com)")

          private def parse(response)
            JSON.parse(response.body).deep_symbolize_keys!
          end
        end
      end
    end
  end
end
