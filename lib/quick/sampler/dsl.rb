require_relative "config"
require_relative "base"
require_relative "dsl/fluidiom"
require_relative "dsl/one_of_weighted"
require_relative "dsl/numeric"
require_relative "dsl/boolean"
require_relative "dsl/string"

module Quick
  module Sampler
    class DSL
      include Quick::Sampler::Config

      def self.compile description: nil, &block
        new.instance_eval(&block).unwrap.tap do |sampler|
          sampler.description = description
        end
      end

      def feed &block
        Fluidiom.new(Base.new(block), config)
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

      def list_of sampler, non_empty: false
        lower_bound = non_empty ? 1 : 0
        feed { sampler.take(rand(lower_bound..upper_bound)) }
      end

      def vector_of length, sampler
        feed { sampler.take(length).force }
      end

      private

    end
  end
end
