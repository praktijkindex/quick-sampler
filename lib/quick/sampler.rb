require_relative "sampler/version"
require_relative "sampler/dsl"

# TODO is this a good API?
module Quick
  def self.sampler(&block)
    Sampler::DSL.new.instance_eval(&block).unwrap
  end
end

