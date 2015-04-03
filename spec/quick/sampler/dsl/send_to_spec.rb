describe Quick::Sampler::DSL do
  it { is_expected.to have_method :send_to }
  let(:dsl) { subject }

  describe "#send_to" do
    let(:sampled_results) {
      dsl.send_to(*args).first(5)
    }
    let(:two) { double("two", value: 2, string: "two") }
    let(:three) { double("three", value: 3, string: "three") }
    before do
      allow(two).to receive(:times) { |x| 2 * x }
      allow(three).to receive(:times) { |x| 3 * x }
    end

    context "given object and method" do
      let(:args) { [two, :value] }
      it "samples a method call result" do
        expect(sampled_results).to all be == 2
      end
    end

    context "given object, method and argument" do
      let(:args) { [two, :times, 3] }
      it "samples a method call result" do
        expect(sampled_results).to all be == 6
      end
    end

    context "given a sampler as the only argument" do
      let(:args) { [ dsl.one_of([two, dsl.one_of(:value, :string)], [three, :times, 4]) ] }
      it "samples the message argument" do
        expect(sampled_results).to all eq(2).or eq("two").or eq(12)
      end
    end

    context "given a sampler as the first argument" do
      let(:args) { [two, dsl.one_of(:value, :string)] }
      it "samples the object to send to" do
        expect(sampled_results).to all eq(2).or eq("two")
      end
    end

    context "given a sampler as a second argument" do
      let(:args) { [dsl.one_of(two, three), :value] }
      it "samples a message to send" do
        expect(sampled_results).to all eq(2).or eq(3)
      end
    end

    context "given a sampler as third argument" do
      let(:args) { [two, :times, dsl.one_of(2,3,4)] }
      it "samples the message argument" do
        expect(sampled_results).to all eq(4).or eq(6).or eq(8)
      end
    end
  end
end
