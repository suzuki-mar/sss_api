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

  def self.create_validate_error_from_message_and_model_name(message, model_name)
    messages = {}
    messages[model_name] = message
    ErrorResponse.create_validate_error_from_messages(messages)
  end

  def self.create_validate_error_from_messages(messages)
    object = ErrorResponse.new
    object.status = 400
    object.message = ''

    messages.each do |key, message|

      object.message += "#{key}:\t"

      msgs = if message.instance_of?(Array)
               message
             else
               [message]
             end
      msgs.each do |msg|
        object.message += "#{msg}\t"
      end
      object.message.chop!

      object.message += "\n\n"
    end

    object
  end

  def self.create_from_exception(error)
    error_messages = {}
    error_messages['error'] = error.message

    return self.create_validate_error_from_messages(error_messages)
  end

  def to_hash
    {
        "message": self.message
    }
  end

end