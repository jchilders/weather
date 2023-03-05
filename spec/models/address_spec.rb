# frozen_string_literal: true

require "dry-monads"

describe Address do
  subject(:address) { described_class.new(street: street, zip: zip) }

  let(:street) { "1234 Main St" }
  let(:zip) { "12345" }

  context "when initalizing" do
    context "when required values aren't given" do
      let(:street) { nil }

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

    context "when an invalid zip is given" do
      it "throws an error" do
        expect { described_class.new(street: "1234 Main St", zip: "alpha") }.to(raise_error(Dry::Types::CoercionError))
      end
    end

    context "when values that aren't required aren't provided" do
      describe "they should be nil" do
        it "city should be nil" do
          expect(address.city).to(be_nil)
        end

        it "state should be nil" do
          expect(address.state).to(be_nil)
        end
      end
    end
  end
end
