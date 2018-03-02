class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :video, touch: true

  validates :content, presence: true
  validates :rating, presence: true
end
