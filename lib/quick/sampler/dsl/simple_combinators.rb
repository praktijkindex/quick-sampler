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

      def one_of *args
        feed { recursive_sample(args.sample) }
      end

      def one_of_weighted expression_weights
        total_weight, expressions = expression_weights
          .reduce([0, {}]) { |(total_weight, expressions), (expression, weight)|
            total_weight += weight
            [total_weight, expressions.merge(total_weight => expression)]
          }

        feed {
          dice = rand * total_weight
          weight_class = expressions.keys.find{|w| dice < w}
          recursive_sample(expressions[weight_class])
        }
      end

      def list_of sampler, non_empty: false
        lower_bound = non_empty ? 1 : 0
        feed { sampler.take(rand(lower_bound..upper_bound)) }
      end

      def vector_of length, sampler
        feed { sampler.take(length).force }
      end

      def list_like *args
        feed { args.map { |arg| recursive_sample(arg) } }
      end

      def send_to *args
        call_sampler = if args.count > 1
                         list_like *args
                       else
                         args.first
                       end
        feed {
          object, message, *args = call_sampler.next
          object.send( message, *args )
        }
      end

      private

      def recursive_sample value
        case value
        when Quick::Sampler
          value.next
        when Hash
          value.map{ |key, value| [key, recursive_sample(value)] }.to_h
        when Array
          value.map{ |value| recursive_sample(value) }
        else
          value
        end
      end

    end
  end
end
