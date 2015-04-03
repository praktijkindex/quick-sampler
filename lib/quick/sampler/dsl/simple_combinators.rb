module Quick
  module Sampler
    module DSL::SimpleCombinators

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

      def one_of_weighted sampler_weights
        total_weight, samplers = sampler_weights
          .reduce([0, {}]) { |(total_weight, samplers), (sampler, weight)|
            total_weight += weight
            [total_weight, samplers.merge(total_weight => sampler)]
          }

        feed {
          dice = rand * total_weight
          weight_class = samplers.keys.find{|w| dice < w}
          samplers[weight_class].next
        }
      end

      def list_like *args
        feed { args.dup }
      end

    end
  end
end
