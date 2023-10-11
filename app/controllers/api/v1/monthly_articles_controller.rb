class Api::V1::MonthlyArticlesController < Api::V1::BaseApiController
  before_action :authenticate_user!

  def index
    monthly_articles = MonthlyArticle.all
    render json: monthly_articles
  end

  def create
    monthly_article = current_user.monthly_articles.build(monthly_article_params)
    if monthly_article.save
      render json: monthly_article, status: :created
    else
      render json: monthly_article.errors, status: :unprocessable_entity
    end
  end

  def show
    monthly_article = MonthlyArticle.find(params[:id])
    render json: monthly_article
  end

  def update
    monthly_article = current_user.monthly_articles.find(params[:id])
    if monthly_article.update(monthly_article_params)
      render json: monthly_article
    else
      render json: monthly_article.errors, status: :unprocessable_entity
    end
  end

  def destroy
    monthly_article = current_user.monthly_articles.find(params[:id])
    monthly_article.destroy!
    head :no_content
  end

  private

    # Storong Parameter
    def monthly_article_params
      params.require(:monthly_article).permit(:beginning_of_month, :body)
    end
end
