class VideosController < ApplicationController
  before_action :require_user

  def index
    @videos = Video.all
    @categories = Category.all
  end

  def show
    @video = VideoDecorator.decorate(Video.find params[:id])
    @reviews = ReviewDecorator.decorate_collection(@video.reviews)
  end

  def search
    @results = Video.search_by_title(params[:search_term])
  end
end
