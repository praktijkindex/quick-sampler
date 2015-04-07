module Quick
  module Sampler
    # DSL methods that allow to combine samplers in various ways.
    #
    # ### Recursive samplers
    #
    # Some of the combinators are recursive: given a nested structure of Arrays and Hashes
    # containing samplers and non-sampler values they would produce an analogous structure
    # where samplers are replaced by their `#next` value.
    module DSL::SimpleCombinators

      # @return [Quick::Sampler]
      #   a sampler producing values from the range or array
      def pick_from source
        case source
        when Range
          feed { rand(source) }
        else
          feed { source.to_a.sample }
        end
      end

      # @return [Quick::Sampler]
      #   a sampler that recursively samples on of the arguments at random
      def one_of *args
        feed { recursive_sample(args.sample) }
      end

      # @return [Quick::Sampler]
      #   a sampler that recursively samples on of the expressions at random, with
      #   likelyhood of picking one of the expressions depends on its weight.
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

      # Sampler of uniform arrays
      #
      # @return [Quick::Sampler]
      #   a sampler that produces arrays of values sampled from its argument
      # @param [Quick::Sampler] sampler
      #   a sampler to sample array elements from
      # @param [Integer, Range, Quick::Sampler<Intger>] size
      #   value to use as, range to pick from or sampler to sample from the list size
      def list_of sampler, size: 1..10
        size = case size
               when Quick::Sampler
                 size
               when Range
                 pick_from(size)
               when Numeric
                 const(size.to_i)
               else
                 raise "Cant use #{size.inspect} as size"
               end
        feed { sampler.first(size.next) }
      end

      # Sampler of arbitrary nested structures made up of `Array`s, `Hash`es, `Quick::Sampler`s and
      # non-sampler values
      #
      # @param [Array] args
      #   a template structure
      # @return [Quick::Sampler]
      #   a recursive sampler
      def list_like *args
        feed { args.map { |arg| recursive_sample(arg) } }
      end

      # Sampler of hashe's that in turn may contain `Array`s, `Hash`es and `Quick::Sampler`s.
      # @param [Hash] pattern
      #   a hash that will be used as a template for samples
      # @return [Quick::Sampler<Hash>]
      #   a recursive sampler of hashes
      def hash_like template
        send_to list_like(template), :first
      end

      # Sampler of arbitrary message send ("method call") results
      #
      # @overload send_to recipient, message, *args
      #   @param [Object, Quick::Sampler<Object>] recipient
      #     message recipient or a sampler producing recipients
      #   @param [Symbol, Quick::Sampler<Symbol>] message
      #     message to send or a sampler producing messages
      #   @param [Array] args
      #     argument list that may contain samplers producing arguments
      #
      # @overload send_to sampler
      #   @param [Quick::Sampler<[Object, Symbol, *Anything]>] sampler
      #     a sampler producing the message send details
      #
      # @return [Quick::Sampler]
      #   a sampler of dynamically generated message send results
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

      # Arbitrary object sampler.
      #
      # @param [Class, Quick::Sampler<Class>] the_class
      #   a class of the object to create (or a sampler producing classes)
      # @param [*Anything] *args
      #   arguments to pass to the constructor (may contain samplers)
      def object_like the_class, *args
        send_to(the_class, :new, *args)
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
