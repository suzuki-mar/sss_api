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
    save_action(self_care_params)
  end

  def create
    @self_care = SelfCare.new
    save_action(self_care_params)
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
    save_action(save_parms)
  end

  def log_date_line_graph
    month_date = MonthDate.new(params["year"], params["month"])

    unless month_date.valid
      error_response = ErrorResponse.create_validate_error_from_messages(month_date.error_messages)
      render_with_error_response(error_response)
      return
    end

    list = SelfCare.by_month_date(month_date)
    items = list.map do |model|
      DateValueLineGraphItem.new(model.log_date_time, model.point)
    end

    items.sort_by!{|item| item.date}
    render_success_with_list_and_date_range(items, month_date)
  end

  private
  def save_action(save_params)
    classification_id_error_response = create_error_response_of_unexist_classificaton_id
    if classification_id_error_response
      render_with_error_response(classification_id_error_response)
      return
    end

    @self_care.assign_attributes(save_params)

    begin
      @self_care.save!
    rescue ActiveRecord::RecordInvalid => e
      error_response = ErrorResponse.create_validate_error_from_messages({self_care: e.message})
      render_with_error_response(error_response)
      return
    end

    render_success_with(@self_care)
  end

  def create_error_response_of_unexist_classificaton_id
    classification_id = self_care_params[:self_care_classification_id]

    unless SelfCareClassification.exists?(id: classification_id)
      error_response = ErrorResponse.create_validate_error_from_messages(
          {self_care_classification: "存在しないIDを渡しました#{classification_id}"}
      )
      return error_response
    end

    return nil
  end


  def set_self_care
    @self_care = SelfCare.find(params[:id])
  end

  def self_care_params
    params.require(:self_care).permit(:log_date, :am_pm, :point, :reason, :self_care_classification_id)
  end

end
