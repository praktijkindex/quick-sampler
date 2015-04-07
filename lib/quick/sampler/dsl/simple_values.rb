module Quick
  module Sampler
    # Samplers of simple values to form the basis of the sampled data structure.
    #
    # ### Note from the future
    #
    # In the future simple values are sampled from other excellent Gems from behind a
    # composable Quick Sampler API. In the mean time this is possible at the cost of
    # readablity:
    #
    # @example Faker integration
    #
    #   Quick::Sampler.compile description: "email address" do
    #     feed { Faker::Internet.email }
    #   end
    module DSL::SimpleValues

      # Degenerate constant sampler. Will probably be superseeded by
      # a cleaner smarter syntax as I get a better hang of it.
      #
      # @return [Quick::Sampler<Anything>] a sampler of constant value
      # @param [Anything] const
      #   the value to keep on sampling
      def const const
        feed { const }
      end

      # Degenerate sampler of zeros. Like {#const} this will probably
      # go away soon.
      #
      # @return [Quick::Sampler<0>] a sampler of zeros
      def zero
        const 0
      end

      FixnumRange = -(2**(0.size * 8 -2))..(2**(0.size * 8 -2) -1)
      private_constant :FixnumRange

      # Samples random fixnums (smaller integers that can be handled quickly by
      # the CPU itself)
      #
      # @return [Quick::Sampler<Fixnum>] a sampler of fixnums
      def fixnum
        pick_from(FixnumRange)
      end

      # @return [Quick::Sampler<Fixnum>] a sampler of negative fixnums
      def negative_fixnum
        pick_from(FixnumRange.min..-1)
      end

      # @return [Quick::Sampler<Fixnum>] a sampler of positive fixnums
      def positive_fixnum
        pick_from(1..FixnumRange.max)
      end

      # A sampler of integers prefering smaller ones
      #
      # It will however sample a large one (from the Fixnum range) occasionally.
      #
      # @return [Quick::Sampler<Fixnum>] a sampler of integers
      def integer
        one_of_weighted(fixnum => 5,
                        pick_from(-1_000_000_000..1_000_000_000) => 7,
                        pick_from(-1000..1000) => 9,
                        pick_from(-100..100) => 11,
                        pick_from(-20..20) => 17)
      end

      alias_method :negative_integer, :negative_fixnum
      alias_method :positive_integer, :positive_fixnum

      # @return [Quick::Sampler<Boolean>] a sampler of `true` and `false` values
      def boolean
        pick_from([true, false])
      end

      # The sampler will produce strings of whose length is controlled by
      # `size:` argument made up of characters belonging to supplied named
      # classes.
      #
      # @returns [Quick::Sampler<String>] random `String` sampler
      # @param [Array<Symbol>] *classes
      #   Character classes to pick from.
      # @todo document character classes
      # @param [Integer, Range, Quick::Sampler<Integer>] size:
      #   Length of the string to generate
      def string *classes, size: pick_from(1..10)
        classes = [:printable] if classes.empty?
        repertoire = DSL::CharacterClass.expand(*classes)
        size = pick_from(size) if Range === size
        send_to( send_to(repertoire, :sample, size), :join )
      end

    end
  end
end
