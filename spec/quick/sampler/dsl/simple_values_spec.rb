describe Quick::Sampler::DSL do
  let(:dsl) { Quick::Sampler::DSL.new }
  it { is_expected.to have_method :const }

  describe "#const" do
    subject(:samples) { dsl.const(Math::PI).first(5) }
    it { is_expected.to all be == Math::PI }
  end
end
