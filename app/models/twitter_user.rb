require 'twitter'
class TwitterUser < ActiveRecord::Base
  has_many :tweets

  def fetch_tweets!
    tweets.size == 0 ? since = 1 : since = tweets.last.tweet_id.to_i
    puts since
    TWITTER.user_timeline(self.user_name, since_id: since, count: 10).reverse.each do |tweet|
      tweets.create!(content: tweet.text, tweet_id: tweet.id)
    end
  end
end
