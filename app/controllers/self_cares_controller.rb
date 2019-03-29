class SelfCaresController < ApiControllerBase

  include Swagger::SelfCaresApi

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
    save_action
  end

  def create
    @self_care = SelfCare.new
    save_action
  end

  def recent
    self_cares = SelfCare.recent
    render_success_with_list(self_cares)
  end

  def month
    month_date = MonthDate.new(params["year"], params["month"])

    unless month_date.valid
      error_response = ErrorResponse.create_validate_error_from_messages(month_date.error_messages)
      render_with_error_response(error_response)
      return
    end

    problem_solvings = SelfCare.by_month_date(month_date)
    render_success_with_list(problem_solvings)
  end

  private
  def save_action
    classification_id_error_response = create_error_response_of_unexist_classificaton_id
    if classification_id_error_response
      render_with_error_response(classification_id_error_response)
      return
    end

    @self_care.assign_attributes(self_care_params)

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
