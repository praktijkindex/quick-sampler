require_relative "sampler/autoload"
require "active_support/core_ext/module/delegation"

module Quick
  # A façade module with the main entry point: {.compile}
  module Sampler

    class << self

      # Main entry point of Quick Sampler. Compiles a definition into a sampler.
      #
      # @param [String] description sampler description which
      #   will be returned by `#inspect` as well as `#description`
      #
      # @param block sampler definition. Will be `instance_eval`ed in the context of an
      #   anonymous instance of {Quick::Sampler::DSL}.
      #
      # @return [Quick::Sampler] compiled sampler
      #
      # @!method compile(description: nil, &block)
      delegate :compile, to: Quick::Sampler::DSL

      # @api private
      #
      # Tests if `obj` is an instance of a known Quick Sampler sub-type.
      #
      # @param [Object] obj the object to test
      # @return [Boolean] true if the object is of a Quick Sampler sub-type
      def === obj
        Base === obj || DSL::Fluidiom === obj
      end
    end
  end
end

