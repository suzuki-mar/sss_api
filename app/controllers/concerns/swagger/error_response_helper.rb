class Swagger::ErrorResponseHelper

  include Swagger::Blocks

  def self.define_bad_request_response(response_node, key_name)

    response_node.response 400 do
      key :description, "#{key_name}が正しくありません:ErrorSchemaの実態クラス"

      schema do
        key :required, [:message]
        property :message do
          key :type, :string
          key :example, "#{key_name} invalid parameter"
        end
      end

    end
  end

  def self.define_validation_failure_response(response_node, model_name)

    response_node.response 400 do
      key :description, "#{model_name}のバリデーションに失敗しました:ErrorSchemaの実態クラス"

      schema do
        key :required, [:message]
        property :message do
          key :type, :string
          key :example, "#{model_name} validation failure [attr_name]:[message]"
        end
      end

    end
  end

  def self.define_not_found_response(response_node, key_name, model_name)

    response_node.response 404 do
      key :description, "指定した#{key_name}の#{model_name}は存在しません::ErrorSchemaの実態クラス"

      schema do
        key :required, [:message]
        property :message do
          key :type, :string
          key :example, "not found #{model_name}"
        end
      end

    end

  end

end