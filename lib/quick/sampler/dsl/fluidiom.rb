require "delegate"
require_relative "../config"

module Quick
  module Sampler
    class Fluidiom < SimpleDelegator
      include Quick::Sampler::Config

      def initialize sampler, _config = {}
        super(sampler)
        config.merge! _config
      end

      def unwrap
        __getobj__
      end

      def spawn sampler
        self.class.new(sampler, config)
      end

      def such_that &predicate
        spawn(unwrap.take(max_iterations).select(&predicate))
      end

    end

  end
end
