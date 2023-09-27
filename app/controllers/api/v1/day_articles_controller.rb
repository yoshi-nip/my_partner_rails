class Api::V1::DayArticlesController < ApplicationController
  def index
    day_articles = DayArticle.all
    render json: day_articles
    # ,each_serializer: DayArticleSerializer
  end

  def create
    day_article = DayArticle.new(day_article_params)
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
    day_article = DayArticle.find(params[:id])
    if day_article.update(day_article_params)
      render json: day_article
    else
      render json: day_article.errors, status: :unprocessable_entity
    end
  end

  def destroy
    day_article = DayArticle.find(params[:id])
    day_article.destroy!
    head :no_content
  end
end
