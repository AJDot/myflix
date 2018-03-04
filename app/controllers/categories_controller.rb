class CategoriesController < ApplicationController
  def show
    @category = Category.find params[:id]
    @videos = sort_videos
  end
end

private

def sort_videos
  videos = @category.videos

  case params[:sort_by]
  when 'z-a'
    videos = videos.sort do |a, b|
      b.title <=> a.title
    end
  when 'rating'
    videos = videos.sort_by(&:rating)
  else # 'a-z'
    videos = videos.sort_by(&:title)
  end

  videos
end
