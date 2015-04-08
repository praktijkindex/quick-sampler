module Quick
  module Sampler
    # A domain specific method for sampler definitions.
    #
    # Instance methods of this class are available as barewords inside a
    # sampler definition supplied as a block to {Quick::Sampler.compile}.
    #
    # Methods that produce a sampler actually wrap it in a {Fluidiom} instance
    # that adds a fluid API to the sampler. This wrapping is stripped off from
    # the sampler returned by {Quick::Sampler.compile} - although I'm still
    # undesided if that's the right thing to do.
    #
    # (Incidentally, {Fluidiom} instances for deeper nested sub-samplers get
    # leaked from compile at the moment)
    class DSL
      include SimpleValues
      include SimpleCombinators

      # @api private
      # @param [Binding] binding a context to lookup unknown methods
      def initialize binding = nil
        setup_delegation(binding) if binding
      end

      # @api private
      # (see Quick::Sampler.compile)
      def self.compile description: nil, &block
        new(block.binding).instance_eval(&block).unwrap.tap do |sampler|
          sampler.description = description
        end
      end

      # overloaded to display human readable text in tests output
      def inspect
        "Quick Sampler DSL"
      end

      # Sample an enumerable or block
      #
      # The block is ignored if `enum` parameter isn't `nil`
      #
      # @param [Enumerable] enum
      #   an enumerable to sample values from
      # @yieldreturn [<Sample>] a sampled value
      def feed enum = nil, &block
        enum ||= block if block_given?
        Fluidiom.new(Base.new(enum))
      end

      private


      def setup_delegation binding
        @context = binding.eval("self")

        # this poor man's delegation is because inheriting from SimpleDelegator breaks
        # autoload for some reason

        # @!visibility private
        def self.method_missing *args, &block
          @context.send(*args, &block)
        end

        # @!visibility private
        def self.respond_to? *args
          super || @context.respond_to?(*args)
        end
      end
    end
  end
end
