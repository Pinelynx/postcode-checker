FactoryBot.define do
  factory :supported_postcode do
    supported_lsoa
    postcode { FFaker::AddressUK.postcode }
  end
end
