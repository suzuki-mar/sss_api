class ErrorResponseException < StandardError

  public
  attr_reader :error_response

  def initialize(message, error_response)
    super(error_response.message)
    @error_response = error_response
  end

  def self.create_from_error_response(error_response)
    ErrorResponseException.new(error_response.message, error_response)
  end

end