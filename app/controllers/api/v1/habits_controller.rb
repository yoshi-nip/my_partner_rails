class Api::V1::HabitsController < ApplicationController
  def index
    habits = Habit.all
    render json: habits
  end
end
