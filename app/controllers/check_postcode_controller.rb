class CheckPostcodeController < ApplicationController
  rescue_from ActionController::ParameterMissing, with: :missing_parameter

  def index; end

  def check
    @error = CheckPostcodeService.instance.call(postcode_param)

    if @error.nil?
      render partial: 'check_postcode/success'
    else
      render partial: 'check_postcode/error'
    end
  end

  private

  def postcode_param
    params.require(:postcode)
  end

  def missing_parameter
    @error = 'Postcode is mandatory!'
    render status: :unprocessable_entity, partial: 'check_postcode/error'
  end
end
