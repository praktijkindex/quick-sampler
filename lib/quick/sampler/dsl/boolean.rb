module Quick
  module Sampler
    class DSL
      def boolean
        pick_from(true, false)
      end
    end
  end
end
