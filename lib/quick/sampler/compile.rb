require_relative "dsl"

require "active_support/core_ext/module/delegation"

module Quick
  module Sampler
    class << self
      delegate :compile, to: DSL
    end
  end
end
