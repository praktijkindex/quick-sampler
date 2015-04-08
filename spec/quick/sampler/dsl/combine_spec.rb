describe Quick::Sampler::DSL do
  it { is_expected.to have_method :combine }

  describe "#combine" do
    let(:dsl) { described_class.new }
    let(:english) { dsl.feed(["one", "two"]) }
    let(:dutch) { dsl.feed(["één", "twee"]) }
    subject(:combined) { dsl.combine(english, dutch) {|e,d| "#{e} = #{d}"}.force }
    it { is_expected.to eq ["one = één", "two = twee"] }
  end
end
