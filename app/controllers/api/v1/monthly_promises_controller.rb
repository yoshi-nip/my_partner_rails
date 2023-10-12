class Api::V1::MonthlyPromisesController < Api::V1::BaseApiController
  before_action :authenticate_user!

  def index
    monthly_promises = MonthlyPromise.all
    render json: monthly_promises
  end

  def create
    monthly_promise = current_user.monthly_promises.build(monthly_promise_params)
    if monthly_promise.save
      render json: monthly_promise, status: :created
    else
      render json: monthly_promise.errors, status: :unprocessable_entity
    end
  end

  def show
    monthly_promise = MonthlyPromise.find(params[:id])
    render json: monthly_promise
  end

  def update
    monthly_promise = current_user.monthly_promises.find(params[:id])
    if monthly_promise.update(monthly_promise_params)
      render json: monthly_promise
    else
      render json: monthly_promise.errors, status: :unprocessable_entity
    end
  end

  def destroy
    monthly_promise = current_user.monthly_promises.find(params[:id])
    monthly_promise.destroy!
    head :no_content
  end

  private

    # Storong Parameter
    def monthly_promise_params
      params.require(:monthly_promise).permit(:beginning_of_month, :body, :if_then_plan)
    end
end
