require_relative "config"
require_relative "composable_sampler"
require_relative "dsl/one_of_weighted"
require_relative "dsl/numeric"
require_relative "dsl/boolean"
require_relative "dsl/string"

module Quick
  module Sampler
    class DSL
      include Quick::Sampler::Config

      def feed &block
        ComposableSampler.new(build_sampler(block), config)
      end

      def const const
        feed { const }
      end

      def pick_from source
        case source
        when Range
          feed { rand(source) }
        when Array
          feed { source.sample }
        end
      end

      def one_of *samplers
        feed { samplers.sample.next }
      end

      private

      def build_sampler callable
        Enumerator.new do |recipient|
          loop do
            recipient << callable.call
          end
        end.lazy
      end
    end

  end
end
