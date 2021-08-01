class SupportedPostcode < ApplicationRecord
  POSTCODE_REGEX = /\A[a-z]{1,2}\d[a-z\d]?\s*\d[a-z]{2}\Z/i

  belongs_to :supported_lsoa

  validates :postcode, presence: true, format: { with: POSTCODE_REGEX,
                                                 message: I18n.t('postcodes.errors.invalid_postcode_format') }

  def postcode=(postcode)
    self[:postcode] = postcode&.strip&.squish
  end
end
