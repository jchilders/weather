# frozen_string_literal: true

module Nws
  describe Points do
    let(:coords) { { latitude: 33.10672410269946, longitude: -96.73356067185759 } }

    describe "the endpoint" do
      context "when it is unreachable" do
        before do
          allow(described_class).to(receive(:get).and_raise(SocketError))
        end

        subject(:result) { described_class.new.call(coords) }

        it "fails gracefully" do
          expect(result.failure?).to(be(true))
        end
      end

      context "when the expected response is returned from the API" do
        subject(:result) do
          VCR.use_cassette("nws/points_success") do
            described_class.new.call(coords)
          end
        end

        it "is successful" do
          expect(result.success?).to(be(true))
        end

        it "got the grid data" do
          expect(result.success).to(eq({
            grid_id: "FWD",
            grid_x: 91,
            grid_y: 117,
          }))
        end
      end
    end
  end
end
