class MonthlyPromiseSerializer < ActiveModel::Serializer
  attributes :id, :beginning_of_month, :body, :if_then_plan, :updated_at, :user_id
  belongs_to :user, serializer: Api::V1::UserSerializer
end
