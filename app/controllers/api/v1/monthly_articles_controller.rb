class Api::V1::MonthlyArticlesController < Api::V1::BaseApiController
  def index
    monthly_articles = MonthlyArticle.all
    render json: monthly_articles
  end
end
