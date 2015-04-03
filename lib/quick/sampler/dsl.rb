module Quick
  module Sampler
    class DSL
      include Quick::Sampler::Config
      include SimpleValues
      include SimpleCombinators

      def self.compile description: nil, &block
        new.instance_eval(&block).unwrap.tap do |sampler|
          sampler.description = description
        end
      end

      def inspect
        "Quick Sampler DSL"
      end

      def feed &block
        Fluidiom.new(Base.new(block), config)
      end
    end
  end
end
