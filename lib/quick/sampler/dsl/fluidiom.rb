require "delegate"

module Quick
  module Sampler
    # SimpleDelegator so that it can unwrap the "original" sampler with #__getobj__
    class DSL::Fluidiom < SimpleDelegator
      include Quick::Sampler::Config

      def initialize sampler, _config = {}
        sampler = Base.new(sampler) unless sampler.is_a? Base
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
