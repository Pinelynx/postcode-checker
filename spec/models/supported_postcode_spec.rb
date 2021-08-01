require 'rails_helper'

RSpec.describe SupportedPostcode, type: :model do
  let(:supported_postcode) { build(:supported_postcode) }

  describe '#valid?' do
    it 'is valid when supported_lsoa and valid postcode are present' do
      supported_postcode.postcode = 'EH8 8DX'
      expect(supported_postcode.valid?).to be(true)
    end

    it 'is invalid with empty postcode' do
      supported_postcode.postcode = nil
      expect(supported_postcode.valid?).to be(false)
    end

    it 'is invalid with invalid postcode' do
      supported_postcode.postcode = 'EHH 8DX'
      expect(supported_postcode.valid?).to be(false)
    end

    it 'is invalid with empty supported_lsoa' do
      supported_postcode.supported_lsoa = nil
      expect(supported_postcode.valid?).to be(false)
    end
  end

  describe '#postcode=' do
    context 'when postcode has extra whitespace' do
      let(:supported_postcode) { build(:supported_postcode, postcode: '   EH8      8DX    ') }

      it 'removes leading and trailing whitespaces as well as squishes multiple ones' do
        expect(supported_postcode.postcode).to eq 'EH8 8DX'
      end
    end

    context 'when postcode is nil' do
      let(:supported_postcode) { build(:supported_postcode, postcode: nil) }

      it 'keeps nil value' do
        expect(supported_postcode.postcode).to eq nil
      end
    end
  end
end
