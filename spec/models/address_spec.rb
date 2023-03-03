# frozen_string_literal: true

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
  end

  describe "geocoding" do
    context "when it fails" do
      it "returns an empty array" do
        expect(address.geocode).to(be_empty)
      end
    end
  end
end
