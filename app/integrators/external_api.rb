# frozen_string_literal: true

module ExternalApi
  class << self
    def included(base)
      base.class_eval do
        include(Dry::Transaction)
        include(HTTParty)

        # debug_output($stdout) if Rails.env.local?

        private def response_ok?(response)
          response.ok?
        end
      end
    end
  end
end
