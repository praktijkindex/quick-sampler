require "active_support/configurable"
require "active_support/concern"

module Quick
  module Sampler
    module Config
      extend ActiveSupport::Concern
      include ActiveSupport::Configurable

      included do
        config_accessor(:max_iterations) { 1000 }
      end

      def config options = :none_given
        if options == :none_given
          super()
        else
          config.merge!(options)
          self
        end
      end
    end
  end
end
