describe Quick::Sampler::DSL do
  it { is_expected.to have_method :hash_like }

  describe "#hash_like" do
    let(:dsl) { described_class.new }
    let(:sampled_hashes) {
      dsl.hash_like(template).first(5)
    }
    let(:positive_integer) { dsl.positive_integer }
    let(:negative_integer) { dsl.negative_integer }

    context "given only constants" do
      let(:template) { { air: 1, water: 2 } }
      it "repeats args as is" do
        expect(sampled_hashes).to all eq template
      end
    end

    context "given a hash with samplers" do
      let(:template) { {plus: positive_integer, minus: negative_integer } }
      it "samples from each sampler" do
        expect(sampled_hashes).to all match plus: a_value > 0, minus: a_value < 0
      end
    end

    context "given a combination of samplers and constants" do
      let(:template) { {
        string: "text",
        plus: positive_integer,
        minus: negative_integer,
        pi: 3.14159
      } }
      it "keeps constants as is, but samples the samplers" do
        expect(sampled_hashes).to all match string: "text",
          plus: a_value > 0, minus: a_value < 0, pi: 3.14159
      end
    end

  end
end
