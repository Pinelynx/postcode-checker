class SupportedPostcode < ApplicationRecord
  belongs_to :supported_lsoa

  validates :postcode, presence: true, format: { with: /\A[a-z]{1,2}\d[a-z\d]?\s*\d[a-z]{2}\Z/i,
                                                 message: 'Invalid postcode format' }

  def postcode=(postcode)
    self[:postcode] = postcode&.strip&.squish
  end
end
