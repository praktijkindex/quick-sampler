module Quick
  module Sampler
    module DSL::SimpleValues

      def const const
        feed { const }
      end

      def zero
        const 0
      end

      FixnumRange = -(2**(0.size * 8 -2))..(2**(0.size * 8 -2) -1)

      def fixnum
        pick_from(FixnumRange)
      end

      def negative_fixnum
        pick_from(FixnumRange.min..-1)
      end

      def positive_fixnum
        pick_from(1..FixnumRange.max)
      end

      def integer
        one_of_weighted(negative_integer => 25,
                        positive_integer => 25,
                        zero => 5)
      end

      alias_method :negative_integer, :negative_fixnum
      alias_method :positive_integer, :positive_fixnum

      def boolean
        pick_from([true, false])
      end

      def string *classes
        classes = [:printable] if classes.empty?
        repertoire = DSL::CharacterClass.expand(*classes)
        feed { repertoire.sample(rand(upper_bound)).join }
      end

    end
  end
end
