require 'rails_helper'

RSpec.describe SupportedLsoa, type: :model do
  let(:supported_lsoa) { build(:supported_lsoa) }

  describe '#valid?' do
    it 'is valid with starts_with present' do
      expect(supported_lsoa.valid?).to be(true)
    end

    it 'is invalid with empty starts_with' do
      supported_lsoa.starts_with = nil
      expect(supported_lsoa.valid?).to be(false)
    end
  end
end
