require 'rails_helper'

describe CheckPostcodeController, type: :controller do
  render_views

  let(:check_postcode_service) { CheckPostcodeService.instance }

  describe '#index' do
    context 'when opening form' do
      subject(:request) { get :index }

      it 'returns status 200 and renders index template' do
        request
        expect(response.status).to eq 200
        expect(response).to render_template('index')
      end
    end
  end

  describe '#check' do
    subject(:request) { post :check, params: params }

    let(:params) { { postcode: 'postcode' } }

    context 'when postcode is supported' do
      before { allow(check_postcode_service).to receive(:call).and_return(supported: true) }

      it 'returns status 200 and renders success partial' do
        request
        expect(response.status).to eq 200
        expect(response).to render_template('check_postcode/_success')
      end
    end

    context 'when postcode is not supported' do
      before { allow(check_postcode_service).to receive(:call).and_return(supported: false, message: 'error') }

      it 'returns status 200 and renders error partial' do
        request
        expect(response.status).to eq 200
        expect(response).to render_template('check_postcode/_error')
      end
    end

    context 'when postcode parameter is missing' do
      let(:params) { {} }

      before { allow(check_postcode_service).to receive(:call).and_raise('This should not be raised') }

      it 'returns status 422 and renders error partial' do
        request
        expect(response.status).to eq 422
        expect(response.status).to render_template('check_postcode/_error')
      end
    end
  end
end
