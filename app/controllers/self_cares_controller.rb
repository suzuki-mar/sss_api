class SelfCaresController < ApiControllerBase

  include Swagger::SelfCaresApi
  include ShowListFromLogDateAction

  before_action :set_self_care, only: [:show, :update]

  protected
  # 親クラスで必要となるメソッド
  def target_model_name
    'SelfCare'
  end

  public
  def show
    render_success_with(@self_care)
  end

  def update
    save_action_enable_db_transaction(self_care_params)
  end

  def create
    @self_care = SelfCare.new
    save_action_enable_db_transaction(self_care_params)
  end

  def recent
    recent_list_action(SelfCare)
  end

  def month
    month_list_action(SelfCare)
  end

  def current_create
    @self_care = SelfCare.new

    save_parms = self_care_params.to_h
    save_parms.merge!(SelfCare.create_save_params_of_date(DateTime.now))
    save_action_enable_db_transaction(save_parms)
  end

  private
  def save_action_enable_db_transaction(save_params)
    ActiveRecord::Base.transaction do
      error_messages = create_error_messages_of_save_params
      if error_messages.present?
        error_response = ErrorResponse.create_validate_error_from_messages(error_messages)
        render_with_error_response(error_response)
        return
      end

      @self_care.save_with_params(save_params.to_h)
      render_success_with(@self_care)
    end
  rescue ErrorResponseException => e
    render_with_error_response(e.error_response)
  rescue ActiveRecord::RecordInvalid => e
    error_response = ErrorResponse.create_validate_error_from_message_and_model_name(e.message, :self_care)
    render_with_error_response(error_response)
  rescue => e
    error_response = ErrorResponse.create_from_exception(e)
    render_with_error_response(error_response)
  end

  def create_error_messages_of_save_params
    classification_id = self_care_params[:self_care_classification_id]
    error_messages = {}

    unless SelfCareClassification.exists?(id: classification_id)
      error_messages[:self_care_classification] = "存在しないIDを渡しました#{classification_id}"
    end

    if self_care_params['tag_names_text'].blank?
      error_messages[:tag_names_text] = "tag_names_textが入力されていません"
    end

    error_messages
  end

  def set_self_care
    @self_care = SelfCare.find(params[:id])
  end

  def self_care_params
    params.require(:self_care).permit(:log_date, :am_pm, :point, :reason, :self_care_classification_id, :tag_names_text)
  end

end
