# frozen_string_literal: true

module Nws
  describe Forecast do
    let(:grid) do
      {
        grid_id: "FWD",
        grid_x: 91,
        grid_y: 117,
      }
    end

    describe "the endpoint" do
      context "when it is unreachable" do
        before do
          allow(described_class).to(receive(:get).and_raise(SocketError))
        end

        subject(:result) { described_class.new.call(grid) }

        it "fails gracefully" do
          expect(result.failure?).to(be(true))
        end
      end

      context "when the expected response is returned from the API" do
        subject(:result) do
          VCR.use_cassette("nws/forecast_success") do
            described_class.new.call(grid)
          end
        end

        it "is successful" do
          expect(result.success?).to(be(true))
        end
      end
    end
  end
end
