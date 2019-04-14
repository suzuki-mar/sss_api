class SelfCareClassificationsController < ApiControllerBase

  before_action :set_self_care_classification, only: [:update]

  protected
  # 親クラスで必要となるメソッド
  def target_model_name
    'SelfCareClassification'
  end

  public
  def update
    save_action
  end

  def create
    @self_care_clasification = SelfCareClassification.new
    save_action
  end

  def index
    render_success_with_list(SelfCareClassification.for_selecting)
  end

  private
  def save_action
    save_params = create_save_params

    if save_params["status_group"].nil?
      error_response = ErrorResponse.create_validate_error_from_messages({self_care_classification: "存在しないstatus_group_numberを指定しました:#{status_group_number_param}"})
      return render_with_error_response(error_response)
    end

    @self_care_clasification.assign_attributes(save_params)
    begin
      @self_care_clasification.save!
    rescue ActiveRecord::RecordInvalid => e
      error_response = ErrorResponse.create_validate_error_from_messages({self_care_clasification: e.message})
      render_with_error_response(error_response)
      return
    end

    render_success_with(@self_care_clasification)
  end

  def self_care_classification_params
    params.require(:self_care_classification).permit(:name, :status_group_number)
  end

  def set_self_care_classification
    @self_care_clasification = SelfCareClassification.find(params[:id])
  end

  def create_save_params
    status_group = SelfCareClassification.status_groups.invert[status_group_number_param]

    save_params = self_care_classification_params.to_hash
    save_params["status_group"] = status_group
    #値があると保存に失敗する
    save_params.delete("status_group_number")

    save_params
  end

  def status_group_number_param
    self_care_classification_params["status_group_number"].to_i
  end

end
