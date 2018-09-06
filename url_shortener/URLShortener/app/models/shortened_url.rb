# == Schema Information
#
# Table name: shortened_urls
#
#  id        :bigint(8)        not null, primary key
#  long_url  :string           not null
#  short_url :string
#  user_id   :integer          not null
#

class ShortenedUrl < ApplicationRecord
  validates :user_id, presence: true 
  validates :long_url, presence: true
  validates :short_url, uniqueness: true
  
  def self.new_url(user, long_url)
    short_url = ShortenedUrl.random_code
    ShortenedUrl.create!(user_id: user.id, long_url: long_url, short_url: short_url)
  end
  
  def self.random_code
    while true
      short_random = SecureRandom.urlsafe_base64
      break unless ShortenedUrl.exists?(short_random)
    end
    short_random
  end
  
  def num_clicks
    # ShortenedUrl.visitors.select(:user).count
    visits.count
  end
  
  def num_uniques
    visits.select(:user_id).distinct.count
  end
  
  def num_recent_uniques
  end
  
  belongs_to :submitter,
  primary_key: :id,
  foreign_key: :user_id,
  class_name: :User
  
  has_many :visits,
  primary_key: :id,
  foreign_key: :url_id,
  class_name: :Visit
  
  has_many :visitors,
  through: :visits,
  source: :user
  
end
