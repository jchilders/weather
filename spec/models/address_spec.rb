# frozen_string_literal: true

require "dry-monads"

describe Address do
  subject(:address) { described_class.new(street: "1234 Main St", zip: "12345") }

  context "when initalizing" do
    context "with values that aren't required aren't given" do
      describe "they should be nil" do
        it "city should be nil" do
          expect(address.city).to(be_nil)
        end

        it "state should be nil" do
          expect(address.state).to(be_nil)
        end
      end
    end

    context "when required values aren't given" do
      describe "street is not given" do
        it "throws an error" do
          expect { described_class.new(zip: "12345") }.to(raise_error("Address: option 'street' is required"))
        end
      end

      describe "zip is not given" do
        it "throws an error" do
          expect { described_class.new(street: "1234 Main St") }.to(raise_error("Address: option 'zip' is required"))
        end
      end
    end

    describe "geocoding" do
      let(:geocoder) { instance_double(Census::Geocoder) }

      before do
        allow(Census::Geocoder).to(receive(:new).and_return(geocoder))
      end

      context "when it fails" do
        before do
          allow(geocoder).to(receive(:call).and_return(Dry::Monads::Failure([90, 0])))
        end

        it "returns the north pole" do
          expect(address.geocode).to(eq([90, 0]))
        end
      end

      context "when it succeeds" do
        before do
          allow(geocoder).to(receive(:call).and_return(Dry::Monads::Success([33, -90])))
        end

        it "returns coordinates" do
          expect(address.geocode).to(eq([33, -90]))
        end
      end
    end
  end
end
