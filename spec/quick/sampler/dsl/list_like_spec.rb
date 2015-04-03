describe Quick::Sampler::DSL do
  it { is_expected.to have_method :list_like }

  describe "#list_like" do
    subject(:sampled_lists) {
      Quick::Sampler::DSL.new.list_like(*args).first(5)
    }

    context "given no arguments" do
      let(:args) { [] }
      it "repeats empty lists" do
        expect(sampled_lists).to all(be_empty)
      end
    end

    context "given only constants" do
      let(:args) { [1, 2, 3] }
      it "repeats args as is" do
        expect(sampled_lists).to all(eq args)
      end
    end

    context "given a list of samplers" do
      let(:positive_integer) { Quick::Sampler::DSL.new.positive_integer }
      let(:negative_integer) { Quick::Sampler::DSL.new.negative_integer }
      let(:args) { [positive_integer, negative_integer] }
      it "samples from each sampler" do
        expect(sampled_lists).to all( include( a_value > 0, a_value < 0) )
      end
    end

    context "given a combination of samplers and constants" do
      let(:positive_integer) { Quick::Sampler::DSL.new.positive_integer }
      let(:negative_integer) { Quick::Sampler::DSL.new.negative_integer }
      let(:args) { ["text", positive_integer, negative_integer, 3.14159] }
      it "keeps constants as is, but samples the samplers" do
        expect(sampled_lists).to all( include( "text", a_value > 0, a_value < 0, 3.14159 ) )
      end
    end

  end
end
