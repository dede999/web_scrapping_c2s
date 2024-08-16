class AttemptController < ApplicationController
  def run
    @attempt = Attempt.new(task_id: params[:task_id], url: params[:url])
    WebScrapService.new(@attempt).run
    render json: @attempt.to_json, status: :ok
  end

  def index
    if params[:task_id].nil?
      @attempts = Attempt.all
    else
      @attempts = Attempt.where(task_id: params[:task_id])
    end
    render json: @attempts
  end
end
