class CheckPostcodeService
  include Singleton

  def call(_postcode)
    true
  end
end
