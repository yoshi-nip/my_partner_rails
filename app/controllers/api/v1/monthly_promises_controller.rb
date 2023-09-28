class Api::V1::MonthlyPromisesController < ApplicationController
  def index
    monthly_promises = MonthlyPromise.all
    render json: monthly_promises
  end
end
