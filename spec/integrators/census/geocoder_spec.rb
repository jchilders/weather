# frozen_string_literal: true

module Census
  describe Geocoder do
    let(:address) { Address.new(street: "1234 Main St", zip: "12345") }

    subject(:geocoder) { described_class.new(address) }

    describe "the endpoint" do
      context "when it is unreachable" do
        let(:fp_before) { RSpec::Expectations.configuration.on_potential_false_positives }

        before do
          # The following is needed to silence the warning rspec gives about
          # possible false positives.
          RSpec::Expectations.configuration.on_potential_false_positives = :nothing

          allow(described_class).to(receive(:get).and_throw(SocketError))
        end

        after do
          RSpec::Expectations.configuration.on_potential_false_positives = fp_before
        end

        it "fails gracefully" do
          expect { geocoder.lookup }.not_to(raise_error(SocketError))
        end
      end

      context "when the expected response is returned from the API" do
        # rubocop:disable Layout/LineLength
        let(:body) do
          "{\"result\":{\"input\":{\"address\":{\"zip\":\"75025\",\"city\":\"\",\"street\":\"9603 Custer Rd\",\"state\":\"\"},\"benchmark\":{\"isDefault\":false,\"benchmarkDescription\":\"Public Address Ranges - Census 2020 Benchmark\",\"id\":\"2020\",\"benchmarkName\":\"Public_AR_Census2020\"}},\"addressMatches\":[{\"tigerLine\":{\"side\":\"L\",\"tigerLineId\":\"210484575\"},\"coordinates\":{\"x\":-96.733,\"y\":33.106},\"addressComponents\":{\"zip\":\"75025\",\"streetName\":\"CUSTER\",\"preType\":\"\",\"city\":\"PLANO\",\"preDirection\":\"\",\"suffixDirection\":\"\",\"fromAddress\":\"9601\",\"state\":\"TX\",\"suffixType\":\"RD\",\"toAddress\":\"9609\",\"suffixQualifier\":\"\",\"preQualifier\":\"\"},\"matchedAddress\":\"9603 CUSTER RD, PLANO, TX, 75025\"}]}}"
        end
        # rubocop:enable Layout/LineLength
        let(:response) { instance_double("response", body: body) }

        before do
          allow(described_class).to(receive(:get).and_return(response))
        end

        it "gets the geocoordinates" do
          expect(geocoder.geocode).to(eq([-96.733, 33.106]))
        end
      end
    end
  end
end
