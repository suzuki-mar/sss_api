class ProblemSolvingsController < ApplicationController
  include Swagger::ProblemSolvingApi

  before_action :set_problem_solving, only: [:show, :update, :destroy]

  # GET /problem_solvings
  def index
    @problem_solvings = ProblemSolving.all

    render json: @problem_solvings
  end

  # GET /problem_solvings/1
  def show
    render json: @problem_solving
  end

  # POST /problem_solvings
  def create
    @problem_solving = ProblemSolving.new(problem_solving_params)

    if @problem_solving.save
      render json: @problem_solving, status: :created, location: @problem_solving
    else
      render json: @problem_solving.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /problem_solvings/1
  def update
    if @problem_solving.update(problem_solving_params)
      render json: @problem_solving
    else
      render json: @problem_solving.errors, status: :unprocessable_entity
    end
  end

  # DELETE /problem_solvings/1
  def destroy
    @problem_solving.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_problem_solving
      @problem_solving = ProblemSolving.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def problem_solving_params
      params.require(:problem_solving).permit(:log_date, :is_draft, :problem_recognition, :example_problem)
    end
end
