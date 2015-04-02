require "delegate"
require_relative "config"

module Quick
  module Sampler
    class ComposableSampler < SimpleDelegator
      include Quick::Sampler::Config

      def initialize sampler, _config = {}
        super(sampler)
        config.merge! _config
      end

      def unwrap
        __getobj__.take(max_iterations)
      end

      def spawn sampler
        ComposableSampler.new(sampler, config)
      end

      def such_that &predicate
        spawn(unwrap.select(&predicate))
      end

    end

  end
end
