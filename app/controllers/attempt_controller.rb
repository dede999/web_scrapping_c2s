class AttemptController < ApplicationController
  def index
    if params[:task_id].nil?
      @attempts = Attempt.all
    else
      @attempts = Attempt.where(task_id: params[:task_id])
    end
    render json: @attempts
  end
end
