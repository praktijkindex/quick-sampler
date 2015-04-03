require "delegate"

module Quick
  module Sampler
    class Base < DelegateClass(Enumerator::Lazy)
      def initialize callable
        enumerator = Enumerator.new do |recipient|
          loop do
            recipient << callable.call
          end
        end.lazy

        super(enumerator)
      end
    end
  end
end
