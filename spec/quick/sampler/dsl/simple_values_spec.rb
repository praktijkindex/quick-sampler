describe Quick::Sampler::DSL do
  let(:dsl) { Quick::Sampler::DSL.new }
  it { is_expected.to have_method :const }

  describe "#const" do
    subject(:samples) { dsl.const(Math::PI).first(5) }
    it { is_expected.to all be == Math::PI }
  end

  describe "#string" do
    subject(:samples) { dsl.string(*args).first(5) }
    context "without arguments" do
      let(:args) { [] }
      it { is_expected.to all be_a String }
      it "has length between 1 and 10" do
        expect(samples).to all satisfy { |s| s.length >= 1 && s.length <= 10 }
      end
    end

    context "with fixed size" do
      let(:args) { [size: 10] }
      it { is_expected.to all have_attributes(length: 10) }
    end

    context "with range size" do
      let(:args) { [size: 5..15] }
      it { is_expected.to all satisfy { |s| s.length >= 5 && s.length <= 15 } }
    end

    context "with a character class" do
      let(:args) { [:lower] }
      it { is_expected.to all match /^[a-z]{1,10}$/ }
    end
  end
end
