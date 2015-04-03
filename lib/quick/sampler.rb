require_relative "sampler/autoload"
require "active_support/core_ext/module/delegation"

module Quick
  module Sampler
    class << self
      delegate :compile, to: Quick::Sampler::DSL

      def === obj
        Base === obj || DSL::Fluidiom === obj
      end
    end
  end
end

