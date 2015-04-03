describe Quick::Sampler::DSL do
  it { is_expected.to have_method :list_like }

  describe "#list_like" do
    subject(:sampled_lists) {
      Quick::Sampler::DSL.new.list_like(*args).first(5)
    }

    context "with empty arglist" do
      let(:args) { [] }
      it "repeats empty lists" do
        expect(sampled_lists).to all(be_empty)
      end
    end

    context "with list of constants" do
      let(:args) { [1, 2, 3] }
      it "repeats args as is" do
        expect(sampled_lists).to all(eq args)
      end
    end

  end
end
