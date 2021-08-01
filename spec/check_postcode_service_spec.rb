require 'rails_helper'

RSpec.describe CheckPostcodeService, type: :class do
  subject(:service) { described_class.instance }

  let(:postcode_service_url) { 'http://example.com' }

  describe '#call' do
    before { ENV['POSTCODE_SERVICE_URL'] = postcode_service_url }

    context 'when invalid input' do
      let(:result) { { supported: nil, message: I18n.t('postcodes.errors.invalid_postcode_format') } }

      context 'when postcode is nil' do
        let(:postcode) { nil }

        it 'returns supported: nil and invalid postcode format message' do
          expect(service.call(postcode)).to eq result
        end
      end

      context 'when postcode has invalid format' do
        let(:postcode) { 'ABC EFG' }

        it 'returns supported: nil and invalid postcode format message' do
          expect(service.call(postcode)).to eq result
        end
      end
    end

    context 'when valid input' do
      let(:result) { { supported: true } }

      before do
        supported_lsoa = create(:supported_lsoa, starts_with: 'Abbeyhill')
        create(:supported_postcode, supported_lsoa: supported_lsoa, postcode: 'EH8 8DX')
      end

      context 'when postcode is in the supported list' do
        before { allow(service).to receive(:call_postcode_service).and_raise('This should not be raised') }

        context 'when input postcode has extra whitespace' do
          let(:postcode) { '      EH8     8DX    ' }

          it 'returns supported: true' do
            expect(service.call(postcode)).to eq result
          end
        end

        context 'when input postcode is in expected format' do
          let(:postcode) { 'EH8 8DX' }

          it 'returns supported: true' do
            expect(service.call(postcode)).to eq result
          end
        end
      end

      context 'when postcode is not in the supported list' do
        before do
          stub_request(:get, "#{postcode_service_url}/#{postcode.delete(' ')}")
            .to_return(status: 200, body: { result: { lsoa: returned_lsoa } }.to_json)
        end

        context 'when postcode is not in the supported list but its lsoa is in the supported list' do
          let(:postcode) { 'EH8 8ZZ' }
          let(:returned_lsoa) { 'Abbeyhill - 01' }

          it 'returns supported: true' do
            expect(service.call(postcode)).to eq result
          end
        end

        context 'when postcode is neither in the supported list nor is its lsoa in the supported list' do
          let(:result) { { supported: false, message: I18n.t('postcodes.messages.postcode_not_supported') } }

          let(:postcode) { 'SW1P 3JX' }
          let(:returned_lsoa) { 'Westminster 020C' }

          it 'returns supported: false and returns not supported message' do
            expect(service.call(postcode)).to eq result
          end
        end
      end

      context 'when postcode is not in the supported list and not found on postcode service' do
        let(:result) { { supported: false, message: I18n.t('postcodes.messages.postcode_not_supported') } }

        let(:postcode) { 'SW1P3ZZ' }

        before do
          stub_request(:get, "#{postcode_service_url}/#{postcode.delete(' ')}")
            .to_return(status: 404, body: { error: 'Postcode not found' }.to_json)
        end

        it 'returns supported: false and returns not supported message' do
          expect(service.call(postcode)).to eq result
        end
      end

      context 'when postcode is not in the supported list and postcode service returns unexpected status' do
        let(:result) { { supported: nil, message: I18n.t('postcodes.errors.cannot_fully_check') } }

        let(:postcode) { 'SW1P3ZZ' }

        before { stub_request(:get, "#{postcode_service_url}/#{postcode.delete(' ')}").to_return(status: 503) }

        it 'returns supported: nil and returns cannot fully check postcode message' do
          expect(service.call(postcode)).to eq result
        end
      end
    end
  end
end
