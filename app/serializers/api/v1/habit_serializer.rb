class HabitSerializer < ActiveModel::Serializer
  attributes :id, :name, :start_date, :updated_at, :user_id
  belongs_to :user, serializer: Api::V1::UserSerializer
end
