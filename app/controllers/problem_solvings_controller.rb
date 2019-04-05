class ProblemSolvingsController < ApiControllerBase
  include Swagger::ProblemSolvingApi
  include DraftableAction
  include ShowListFromLogDateAction

  before_action :set_problem_solving, only: [:show, :update, :destroy, :done, :doing, :auto_save]

  protected
  # 親クラスで必要となるメソッド
  def target_model_name
    'ProblemSolving'
  end

  def param_top_key
    :problem_solving
  end

  def create_save_params
    problem_solving_params.to_hash
  end

  def create_error_response_of_params_if_needed
    nil
  end

  public
  # GET /problem_solvings
  def index
    @problem_solvings = ProblemSolving.all

    render json: @problem_solvings
  end

  # GET /problem_solvings/1
  def show
    render_success_with(@problem_solving)
  end

  # POST /problem_solvings
  def create
    @problem_solving = ProblemSolving.new
    draftable_save_action_enable_db_transaction(@problem_solving)
  end

  # PATCH/PUT /problem_solvings/1
  def update
    draftable_save_action_enable_db_transaction(@problem_solving)
  end

  # DELETE /problem_solvings/1
  def destroy
    @problem_solving.destroy
  end

  def recent
    recent_list_action(ProblemSolving)
  end

  def month
    month_list_action(ProblemSolving)
  end

  def init
    init_action(ProblemSolving)
  end

  def auto_save
    draftable_save_action_enable_db_transaction(@problem_solving)
  end

  def done
    @problem_solving.done!
    render_success_with(@problem_solving)
  end

  def doing
    @problem_solving.doing!
    render_success_with(@problem_solving)
  end

  def doings
    progress_status_list_action(:doing)
  end

  def dones
    progress_status_list_action(:done)
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_problem_solving
    @problem_solving = ProblemSolving.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def problem_solving_params
    params.require(:problem_solving).permit(
        :log_date, :is_draft, :problem_recognition, :example_problem, :cause, :phenomenon, :neglect_phenomenon,
        :solution, :execution_method, :evaluation_method, :tag_names_text, :progress_status)
  end

  def progress_status_list_action(status)
    month_date = MonthDate.new(params["year"], params["month"])

    unless month_date.valid
      error_response = ErrorResponse.create_validate_error_from_messages(month_date.error_messages)
      render_with_error_response(error_response)
      return
    end

    list = ProblemSolving.by_month_date(month_date).only_progress_status(status)
    render_success_with_list(list)
  end

end
