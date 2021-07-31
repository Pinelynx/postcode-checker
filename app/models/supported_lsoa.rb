class SupportedLsoa < ApplicationRecord
  has_many :supported_postcodes, inverse_of: :supported_lsoa, dependent: :destroy

  validates :starts_with, presence: true, uniqueness: true
end
