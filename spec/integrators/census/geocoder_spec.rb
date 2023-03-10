# frozen_string_literal: true

module Census
  describe Geocoder do
    let(:address) { Address.new(street: "451 N. 8th St.", zip: "47807") }

    describe "the endpoint" do
      context "when it is unreachable" do
        before do
          allow(described_class).to(receive(:get).and_raise(SocketError))
        end

        subject(:result) { described_class.new.call(address) }

        it "fails gracefully" do
          expect(result.failure?).to(be(true))
        end
      end

      context "when the expected response is returned from the API" do
        subject(:result) do
          VCR.use_cassette("census/geocoder") do
            described_class.new.call(address)
          end
        end

        it "is successful" do
          expect(result.success?).to(be(true))
        end

        it "got the geocoordinates" do
          expect(result.success).to(eq({
            latitude: 39.4713935121389,
            longitude: -87.40576720252876,
          }))
        end
      end
    end
  end
end
