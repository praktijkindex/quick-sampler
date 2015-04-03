describe Quick::Sampler do
  specify do
    expect(Quick::Sampler).to have_method :compile
  end

  context "given a simple script" do
    let(:sampler) { Quick::Sampler.compile { const(:it_lives!) } }
    it "compiles a sampler from a DSL script" do
      expect(sampler).to be_a Quick::Sampler::Base
    end
  end

  context "given a description: option" do
    let(:sampler) {
      Quick::Sampler.compile description: "wine sampler" do
        one_of(:chiraz, :pinot_noir, :riesling)
      end
    }

    it "sets description as sampler's description" do
      expect(sampler.description).to be == "wine sampler"
    end

    it "makes the sampler to return description when inspected" do
      expect(sampler.inspect).to be == "wine sampler"
    end
  end

  context "given an unbound reference in the script" do
    let(:external_thing) { 42 }
    let(:sampler) {
      Quick::Sampler.compile do
        const(external_thing)
      end
    }

    it "resolves it in the context compile was called in" do
      expect(sampler.first).to be 42
    end
  end
end
