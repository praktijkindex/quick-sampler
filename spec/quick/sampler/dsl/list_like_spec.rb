describe Quick::Sampler::DSL do
  it { is_expected.to have_method :list_like }

  describe "#list_like" do
    subject(:sampled_lists) {
      Quick::Sampler::DSL.new.list_like(*args).first(5)
    }
    let(:positive_integer) { Quick::Sampler::DSL.new.positive_integer }
    let(:negative_integer) { Quick::Sampler::DSL.new.negative_integer }

    context "given no arguments" do
      let(:args) { [] }
      it "repeats empty lists" do
        expect(sampled_lists).to all be_empty
      end
    end

    context "given only constants" do
      let(:args) { [1, 2, 3] }
      it "repeats args as is" do
        expect(sampled_lists).to all eq args
      end
    end

    context "given a list of samplers" do
      let(:args) { [positive_integer, negative_integer] }
      it "samples from each sampler" do
        expect(sampled_lists).to all match [a_value > 0, a_value < 0]
      end
    end

    context "given a combination of samplers and constants" do
      let(:args) { ["text", positive_integer, negative_integer, 3.14159] }
      it "keeps constants as is, but samples the samplers" do
        expect(sampled_lists).to all match ["text", a_value > 0, a_value < 0, 3.14159]
      end
    end

    context "given a hash with constant keys and values" do
      let(:args) { [const: 42, another: 666] }
      it "repeats the hash as is" do
        expect(sampled_lists).to all match args
      end
    end

    context "given a hash with sampler values" do
      let(:args) { [positive_integer: positive_integer, negative_integer: negative_integer] }
      it "samples the values" do
        expect(sampled_lists).to all match [positive_integer: a_value > 0, negative_integer: a_value < 1]
      end
    end

    context "given a nested array with samplers" do
      let(:args) { ["outie", ["innie", positive_integer, negative_integer, 3.14159, option: positive_integer]] }
      it "recurses into the array" do
        expect(sampled_lists).to all match ["outie", ["innie", a_value > 0, a_value < 0, 3.14159, option: a_value > 0]]
      end
    end

  end
end
