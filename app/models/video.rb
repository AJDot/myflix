class Video < ActiveRecord::Base
  include Elasticsearch::Model
  # add active record callbacks on video model to elasticsearch is always synced
  include Elasticsearch::Model::Callbacks
  # keeps dev and test environment separate - just like we do for databases
  index_name ["myflix", Rails.env].join('_')
  unless self.__elasticsearch__.index_exists?
    self.__elasticsearch__.create_index!
  end

  belongs_to :category
  has_many :reviews, ->{ order("created_at DESC") }

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  validates :title, presence: true
  validates :description, presence: true

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where("title LIKE ?", "%#{search_term}%").order("created_at DESC")
  end

  def rating
    reviews.average(:rating).round(1) if reviews.average(:rating)
  end
end
