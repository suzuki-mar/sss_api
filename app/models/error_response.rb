class ErrorResponse
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :status, :integer
  attribute :message, :string

  def self.create_not_found(model_name)
    object = ErrorResponse.new
    object.status = 404
    object.message = "#{model_name} not found"

    object
  end

  def self.create_validate_error(messages)
    object = ErrorResponse.new
    object.status = 400
    object.message = ''

    messages.each do |key, message|
      object.message += "#{key}:\t#{message}\n\n"
    end

    object
  end

  def to_hash
    {
        "message": self.message
    }
  end

end