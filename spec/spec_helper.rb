$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "quick/sampler"

RSpec::Matchers.alias_matcher :have_method, :respond_to
