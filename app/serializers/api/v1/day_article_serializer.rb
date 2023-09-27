class Api::V1::DayArticleSerializer < ActiveModel::Serializer
  attributes :id, :body, :day, :updated_at, :user_id
  belongs_to :user, serializer: Api::V1::UserSerializer
end
