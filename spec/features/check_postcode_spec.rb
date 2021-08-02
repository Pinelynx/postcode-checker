require 'rails_helper'

RSpec.describe 'Checking a postcode', type: :feature do
  let(:postcode_service_url) { 'http://example.com' }

  before do
    ENV['POSTCODE_SERVICE_URL'] = postcode_service_url
    supported_lsoa = create(:supported_lsoa, starts_with: 'Abbeyhill')
    create(:supported_postcode, supported_lsoa: supported_lsoa, postcode: 'EH8 8DX')
  end

  context 'when invalid inputs' do
    context 'when postcode is missing' do
      it 'displays correct error message' do # rubocop:disable RSpec/ExampleLength
        visit check_postcode_path
        expect(page.has_content?(I18n.t('postcodes.view.form.prompt'))).to eq true

        click_on I18n.t('postcodes.view.form.button')
        expect(page.has_content?(I18n.t('postcodes.errors.mandatory_postcode'))).to eq true

        click_on I18n.t('postcodes.view.back_to_form_link')
        expect(page.has_content?(I18n.t('postcodes.view.form.prompt'))).to eq true
      end
    end

    context 'when postcode has invalid format' do
      let(:postcode) { 'ABC DEF' }

      it 'displays correct error message' do
        visit check_postcode_path
        expect(page.has_content?(I18n.t('postcodes.view.form.prompt'))).to eq true

        fill_in :postcode, with: postcode

        click_on I18n.t('postcodes.view.form.button')
        expect(page.has_content?(I18n.t('postcodes.errors.invalid_postcode_format'))).to eq true
      end
    end
  end

  context 'when valid inputs' do
    context 'when postcode is supported' do
      context 'when postcode is in the supported postcode list' do
        context 'when postcode has extra whitespace' do
          let(:postcode) { '             EH8         8DX   ' }

          it 'displays postcode supported message' do
            visit check_postcode_path
            expect(page.has_content?(I18n.t('postcodes.view.form.prompt'))).to eq true

            fill_in :postcode, with: postcode

            click_on I18n.t('postcodes.view.form.button')
            expect(page.has_content?(I18n.t('postcodes.messages.postcode_supported'))).to eq true
          end
        end

        context 'when postcode is in expected format' do
          let(:postcode) { 'EH8 8DX' }

          it 'displays postcode supported message' do
            visit check_postcode_path
            expect(page.has_content?(I18n.t('postcodes.view.form.prompt'))).to eq true

            fill_in :postcode, with: postcode

            click_on I18n.t('postcodes.view.form.button')
            expect(page.has_content?(I18n.t('postcodes.messages.postcode_supported'))).to eq true
          end
        end
      end

      context 'when postcode is not in the supported list' do
        before do
          stub_request(:get, "#{postcode_service_url}/#{postcode.delete(' ')}")
            .to_return(status: 200, body: { result: { lsoa: returned_lsoa } }.to_json)
        end

        context 'when postcode is not in the supported postcode list but lsoa is in the supported lsoa list' do
          let(:postcode) { 'EH8 8ZZ' }
          let(:returned_lsoa) { 'Abbeyhill - 01' }

          it 'displays postcode supported message' do
            visit check_postcode_path
            expect(page.has_content?(I18n.t('postcodes.view.form.prompt'))).to eq true

            fill_in :postcode, with: postcode

            click_on I18n.t('postcodes.view.form.button')
            expect(page.has_content?(I18n.t('postcodes.messages.postcode_supported'))).to eq true
          end
        end

        context 'when postcode is neither in the supported postcode list nor is lsoa in the supported lsoa list' do
          let(:postcode) { 'SW1P 3JX' }
          let(:returned_lsoa) { 'Westminster 020C' }

          it 'displays postcode not supported message' do
            visit check_postcode_path
            expect(page.has_content?(I18n.t('postcodes.view.form.prompt'))).to eq true

            fill_in :postcode, with: postcode

            click_on I18n.t('postcodes.view.form.button')
            expect(page.has_content?(I18n.t('postcodes.messages.postcode_not_supported'))).to eq true
          end
        end
      end

      context 'when postcode is not in the supported list and not found on postcode service' do
        let(:postcode) { 'SW1P3ZZ' }

        before do
          stub_request(:get, "#{postcode_service_url}/#{postcode.delete(' ')}")
            .to_return(status: 404, body: { error: 'Postcode not found' }.to_json)
        end

        it 'displays postcode not supported message' do
          visit check_postcode_path
          expect(page.has_content?(I18n.t('postcodes.view.form.prompt'))).to eq true

          fill_in :postcode, with: postcode

          click_on I18n.t('postcodes.view.form.button')
          expect(page.has_content?(I18n.t('postcodes.messages.postcode_not_supported'))).to eq true
        end
      end

      context 'when postcode is not in the supported list and postcode service returns unexpected status' do
        let(:postcode) { 'SW1P3ZZ' }

        before { stub_request(:get, "#{postcode_service_url}/#{postcode.delete(' ')}").to_return(status: 503) }

        it 'displays postcode not supported message' do
          visit check_postcode_path
          expect(page.has_content?(I18n.t('postcodes.view.form.prompt'))).to eq true

          fill_in :postcode, with: postcode

          click_on I18n.t('postcodes.view.form.button')
          expect(page.has_content?(I18n.t('postcodes.errors.cannot_fully_check'))).to eq true
        end
      end
    end
  end
end
