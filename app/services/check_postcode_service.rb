class CheckPostcodeService
  include Singleton

  def call(postcode)
    postcode = postcode&.strip&.squish

    return invalid_postcode_format unless SupportedPostcode::POSTCODE_REGEX.match?(postcode)

    return supported if check_supported_postcodes(postcode)

    response = call_postcode_service(postcode)

    case response
    when Net::HTTPOK then check_response(response)
    when Net::HTTPNotFound then not_supported
    else service_not_available
    end
  end

  private

  def check_supported_postcodes(postcode)
    SupportedPostcode.find_by(postcode: postcode).present?
  end

  def call_postcode_service(postcode)
    uri = "#{ENV['POSTCODE_SERVICE_URL']}/#{postcode.delete(' ')}"
    url = URI.parse(uri)
    request = Net::HTTP::Get.new(url.to_s)

    Net::HTTP.start(url.host, url.port) do |http|
      http.request(request)
    end
  end

  def check_response(response)
    hash = JSON.parse(response.body).deep_symbolize_keys
    lsoa = hash.dig(:result, :lsoa)

    check_supported_lsoas(lsoa) ? supported : not_supported
  end

  def check_supported_lsoas(lsoa)
    SupportedLsoa.find_by('? LIKE starts_with || \'%\'', lsoa).present?
  end

  def supported
    { supported: true }
  end

  def not_supported
    { supported: false, message: I18n.t('postcodes.messages.postcode_not_supported') }
  end

  def service_not_available
    { supported: nil, message: I18n.t('postcodes.errors.cannot_fully_check') }
  end

  def invalid_postcode_format
    { supported: nil, message: I18n.t('postcodes.errors.invalid_postcode_format') }
  end
end
