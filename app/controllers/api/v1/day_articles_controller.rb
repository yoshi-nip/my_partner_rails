class Api::V1::DayArticlesController < Api::V1::BaseApiController
  before_action :authenticate_user!

  def index
    day_articles = DayArticle.all
    render json: day_articles
    # ,each_serializer: DayArticleSerializer
  end

  def create
    day_article = current_user.day_articles.build(day_article_params)
    if day_article.save
      render json: day_article, status: :created
    else
      render json: day_article.errors, status: :unprocessable_entity
    end
  end

  def show
    day_article = DayArticle.find(params[:id])
    render json: day_article
  end

  def update
    day_article = current_user.day_articles.find(params[:id])
    if day_article.update(day_article_params)
      render json: day_article
    else
      render json: day_article.errors, status: :unprocessable_entity
    end
  end

  def destroy
    day_article = current_user.day_articles.find(params[:id])
    day_article.destroy!
    head :no_content
  end

  private

    # Storong Parameter
    def day_article_params
      params.require(:day_article).permit(:body, :day)
    end
end
