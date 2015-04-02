module Quick
  module Sampler
    class DSL
      def zero
        const 0
      end

      def fixnum
        pick_from(min_fixnum..max_fixnum)
      end

      def negative_fixnum
        pick_from(min_fixnum...0)
      end

      def positive_fixnum
        pick_from(1..max_fixnum)
      end

      def integer
        one_of_weighted(negative_integer => 25,
                        positive_integer => 25,
                        zero => 5)
      end

      alias_method :negative_integer, :negative_fixnum
      alias_method :positive_integer, :positive_fixnum

      private

      def min_fixnum
        -(2**(0.size * 8 -2))
      end

      def max_fixnum
        (2**(0.size * 8 -2) -1)
      end

      def fixnum_range
        min_fixnum...max_fixnum
      end
    end
  end
end
