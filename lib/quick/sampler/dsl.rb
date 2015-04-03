module Quick
  module Sampler
    class DSL
      include Quick::Sampler::Config
      include SimpleValues
      include SimpleCombinators

      def initialize binding = nil
        setup_delegation(binding) if binding
      end

      def self.compile description: nil, &block
        new(block.binding).instance_eval(&block).unwrap.tap do |sampler|
          sampler.description = description
        end
      end

      def inspect
        "Quick Sampler DSL"
      end

      def feed &block
        Fluidiom.new(Base.new(block), config)
      end

      private

      def setup_delegation binding
        @context = binding.eval("self")

        # this poor man's delegation is because inheriting from SimpleDelegator breaks
        # autoload for some reason
        def self.method_missing *args, &block
          @context.send(*args, &block)
        end

        def self.respond_to? *args
          super || @context.respond_to?(*args)
        end
      end
    end
  end
end
