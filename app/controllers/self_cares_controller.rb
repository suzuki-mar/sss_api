class SelfCaresController < ApplicationController

  include Swagger::SelfCaresApi

  def show
    self_care = SelfCare.find(params[:id])
    render json: self_care, status: 200
  rescue ActiveRecord::RecordNotFound
    error_object = {message: 'not found'}
    render json: error_object, status: 404
  end

end
