require "delegate"
require_relative "../shrink"

module Quick
  module Sampler
    class Base < DelegateClass(Enumerator::Lazy)
      attr_accessor :description

      def initialize source, description: nil
        @description = description
        super(source_to_lazy(source))
      end

      def inspect
        description || super
      end

      def shrink samples, &block
        Quick::Shrink.while(samples, &block)
      end

      private

      def source_to_lazy source
        case source
        when Enumerator::Lazy
          source
        when Enumerator
          source.lazy
        when ->(i) { i.respond_to? :call }
          Enumerator.new do |recipient|
            loop do
              recipient << source.call
            end
          end.lazy
        else
          raise "Don't know how to make a sampler from #{source.inspect}"
        end
      end
    end
  end
end
