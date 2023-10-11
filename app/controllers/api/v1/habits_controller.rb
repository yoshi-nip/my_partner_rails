class Api::V1::HabitsController < Api::V1::BaseApiController
  before_action :authenticate_user!

  def index
    habits = Habit.all
    render json: habits
    # ,each_serializer: HabitSerializer
  end

  def create
    habit = current_user.habits.build(habit_params)
    if habit.save
      render json: habit, status: :created
    else
      render json: habit.errors, status: :unprocessable_entity
    end
  end

  def show
    habit = Habit.find(params[:id])
    render json: habit
  end

  def update
    habit = current_user.habits.find(params[:id])
    if habit.update(habit_params)
      render json: habit
    else
      render json: habit.errors, status: :unprocessable_entity
    end
  end

  def destroy
    habit = current_user.habits.find(params[:id])
    habit.destroy!
    head :no_content
  end

  private

    # Storong Parameter
    def habit_params
      params.require(:habit).permit(:start_date, :name)
    end
end
