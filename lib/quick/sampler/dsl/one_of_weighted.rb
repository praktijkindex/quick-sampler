module Quick
  module Sampler
    class DSL
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
    end
  end
end
