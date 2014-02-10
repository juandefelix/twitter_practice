require 'twitter'
class TwitterUser < ActiveRecord::Base
  has_many :tweets

  def fetch_tweets!(count=10)
    TWITTER.user_timeline(self.user_name).each do |tweet|
      tweets.create!(content: tweet.text)
    end
  end
end
