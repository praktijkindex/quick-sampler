require "delegate"

module Quick
  module Sampler
    # A sampler base class, delegating most work to the underlying lazy enumerator.
    #
    # ### Readable #inspect
    #
    # One superficial extra that {Sampler::Base} provides is a description attribute
    # which is returned by `#inspect`. This can help keep test output readable.
    #
    # ### Shrinking
    #
    # Sampler::Base also provides an {#shrink api for shrinking} failed inputs.
    #
    # From {http://stackoverflow.com/a/16970029/538534 stackoverflow discussion}
    # of shrinking (follow the link for an example) in the original QuickCheck:
    #
    # > When QuickCheck finds an input that violates a property, it will first
    # try to find smaller inputs that also violate the property, in order to
    # give the developer a better message about the nature of the failure.
    #
    # > What it means to be „small“ of course depends on the datatype in
    # question; to QuickCheck it is anything that comes out from from the
    # shrink function.
    #
    class Base < DelegateClass(Enumerator::Lazy)
      attr_accessor :description

      # @api private
      # Not supposed to be used directly, use {Quick::Sampler.compile} instead.
      #
      # @param [Enumerator, Enumerator::Lazy, #call] source source of data.
      #   Non-lazy `Enumerator` will be lazyfied, and anything `call`able will be
      #   wrapped into a lazy enumerator.
      # @param [String] description sampler description to be returned by #inspect
      def initialize source, description: "Quick Sampler"
        @description = description
        super(source_to_lazy(source))
      end

      # @return [String] sampler description, so test output is readable
      def inspect
        description
      end

      # A very preliminary API for QuickCheck-like input shrinking.
      # A sampler is responsible for shrinking its failed samples.
      #
      # @example Detecting and then shrinking failing examples:
      #
      #   # Generate random input data
      #   all_inputs = sampler.first(100)
      #
      #   # Find failures (by rejecting inputs satisfying the property)
      #   failed_inputs = all_inputs.reject{ |input| property(input) }
      #
      #   # Shrink failed inputs, continue shrinking as long as property does not hold
      #   shrunk_inputs = sampler.shrink(failed_inputs) {|input| !property(input)}
      #
      #
      # @param [Enumerable] samples input samples that failed the preoperty
      #
      # @yieldparam [<Sample>] sample shrunk value to check the property again. If
      #   property holds, the value will be discarded, and the one it was shrunk
      #   from will be added to the set of "minimal" failing examples.
      #
      # @yieldreturn [Boolean] `true` to keep on shrinking, meaning *"property still fails for
      #   shrunken value, try to shrink more"*
      #
      # @return [Array] "minimal" samples that failed to satisfy the property under test
      def shrink samples, &block
        Quick::Sampler::Shrink.while(samples, &block)
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
