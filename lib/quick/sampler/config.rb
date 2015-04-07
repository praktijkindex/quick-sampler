require "active_support/configurable"
require "active_support/concern"

module Quick
  module Sampler
    module Config
      extend ActiveSupport::Concern
      include ActiveSupport::Configurable

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
