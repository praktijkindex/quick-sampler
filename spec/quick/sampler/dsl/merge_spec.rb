describe Quick::Sampler::DSL do
  it { is_expected.to have_method :merge }

  describe "#merge" do
    let(:dsl) { described_class.new }
    let(:defaults_hash) { { prime: 7, negative: -42} }
    let(:first_sampler) { dsl.feed( [{prime: 13}, {negative: -43}] ) }
    let(:second_sampler) { dsl.feed( [{string: "one"}, {string: "two"}] ) }
    subject(:merged) {
      dsl.merge(defaults_hash, first_sampler, second_sampler).force
    }
    it {
      is_expected.to contain_exactly(
        { prime: 13, negative: -42, string: "one" },
        { prime: 7, negative: -43, string: "two" },
      )
    }
  end
end
