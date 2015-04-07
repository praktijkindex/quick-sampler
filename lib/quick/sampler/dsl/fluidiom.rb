require "delegate"

module Quick
  module Sampler
    # A Quick::Sampler wrapper providing a fluid DSL that can be used in a sampler definition
    # passed to {Quick::Sampler.compile}.
    class DSL::Fluidiom < SimpleDelegator
      # SimpleDelegator so that it can unwrap the "original" sampler with `#__getobj__`

      # @api private
      # wraps a `sampler` into a `Fluidiom` instance so it has extra methods while
      # inside the block passed to {Quick::Sampler.compile}
      def initialize sampler
        sampler = Base.new(sampler) unless sampler.is_a? Base
        super(sampler)
      end

      # @return [Quick::Sampler]
      #   the unwrapped original sampler
      def unwrap
        __getobj__
      end

      # @return [Quick::Sampler]
      #   a new fluidiom-wrapped sampler
      def spawn sampler
        self.class.new(sampler)
      end

      # spawn a filtering sampler
      #
      # @param [Integer] max_iterations
      #   try at most this many values before giving up
      # @return [Quick::Sampler]
      #   a sampler that passes through only samples that satisfy the
      #   predicate given as block
      # @yieldparam [Anything] sample
      #   a sampled value to be tested
      # @yieldreturn [Boolean]
      #   `true` to pass the value through
      def such_that max_iterations: 1000, &predicate
        spawn(unwrap.take(max_iterations).select(&predicate))
      end

      # spawn a mapping sampler
      #
      # The produced sampler will yield each original sample to the block and return block
      # result instead.
      #
      # @return [Quick::Sampler]
      #   a sampler that maps each original sample through the block
      # @yieldparam [Anything] sample
      #   the original sample
      # @yieldreturn [Anything]
      #   the mapped sample to return
      def map &block
        spawn(unwrap.map(&block))
      end
    end
  end
end
