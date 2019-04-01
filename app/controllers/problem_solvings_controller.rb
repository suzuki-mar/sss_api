class ProblemSolvingsController < ApiControllerBase
  include Swagger::ProblemSolvingApi
  include DraftableAction
  include ShowListFromLogDateAction

  before_action :set_problem_solving, only: [:show, :update, :destroy, :done]

  protected
  # 親クラスで必要となるメソッド
  def target_model_name
    'ProblemSolving'
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
    draftable_save_action
  end

  # PATCH/PUT /problem_solvings/1
  def update
    draftable_save_action
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

  def done
    @problem_solving.done!
    render_success_with(@problem_solving)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_problem_solving
      @problem_solving = ProblemSolving.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def problem_solving_params
      params.require(:problem_solving).permit(:log_date, :is_draft, :problem_recognition, :example_problem, :cause, :phenomenon, :neglect_phenomenon, :solution, :execution_method, :evaluation_method)
    end

  def draftable_save_action

    if params[:is_draft].nil?
      error_response = ErrorResponse.create_validate_error_from_messages({is_draft: "必須です"})
      render_with_error_response(error_response)
      return
    end

    save_params = problem_solving_params.to_hash
    save_service = DraftableSaveService.new(draft_save?, @problem_solving, save_params)

    if save_service.execute
      render_success_with(@problem_solving)
    else
      error_response = ErrorResponse.create_validate_error_from_messages(save_service.error_messages)
      render_with_error_response(error_response)
    end

  end

end
