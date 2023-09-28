class Api::V1::MonthlyArticleSerializer < ActiveModel::Serializer
  attributes :id, :beginning_of_month, :body, :updated_at, :user_id
  belongs_to :user, serializer: Api::V1::UserSerializer
end
