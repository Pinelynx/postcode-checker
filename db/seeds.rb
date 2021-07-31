%w[Southwark Lambeth].each { |lsoa| SupportedLsoa.find_or_create_by!(starts_with: lsoa) }
custom_lsoa = SupportedLsoa.find_or_create_by!(starts_with: 'Custom')

%w[SH24\ 1AA SH24\ 1AB].each do |postcode|
  SupportedPostcode.find_or_create_by!(postcode: postcode, supported_lsoa: custom_lsoa)
end
