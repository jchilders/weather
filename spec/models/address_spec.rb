# frozen_string_literal: true

require "dry-monads"

describe Address do
  subject(:address) { described_class.new(street: street, zip: zip) }

  let(:street) { "1234 Main St" }
  let(:zip) { "12345" }

  context "when initalizing" do
    it "is valid" do
      expect(address).to(be_valid)
    end

    context "when required values aren't given" do
      describe "street is not given" do
        let(:street) { nil }

        it "is invalid" do
          expect(address).not_to(be_valid)
        end
      end

      describe "zip is not given" do
        let(:zip) { nil }

        it "is invalid" do
          expect(address).not_to(be_valid)
        end
      end
    end

    context "when an invalid zip is given" do
      let(:zip) { "alpha" }

      it "is invalid" do
        expect(address).not_to(be_valid)
      end
    end

    context "when a nine-digit zip is given" do
      let(:zip) { "12345-6789" }

      it "is valid" do
        expect(address).to(be_valid)
      end
    end
  end
end
