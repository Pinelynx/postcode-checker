FactoryBot.define do
  factory :supported_lsoa do
    starts_with { FFaker::AddressUK.city }
  end
end
