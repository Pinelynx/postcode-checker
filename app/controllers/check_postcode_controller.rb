class CheckPostcodeController < ApplicationController
  rescue_from ActionController::ParameterMissing, with: :missing_parameter

  def index; end

  def check
    result = CheckPostcodeService.instance.call(postcode_param)

    if result[:supported]
      render partial: 'check_postcode/success'
    else
      @error = result[:message]
      render partial: 'check_postcode/error'
    end
  end

  private

  def postcode_param
    params.require(:postcode)
  end

  def missing_parameter
    @error = I18n.t('postcodes.errors.mandatory_postcode')
    render status: :unprocessable_entity, partial: 'check_postcode/error'
  end
end
