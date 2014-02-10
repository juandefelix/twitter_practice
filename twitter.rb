require 'twitter'
require_relative 'db/config'
require_relative 'app/models/tweet'
require_relative 'app/models/senator'
require_relative 'app/models/representative'
require_relative 'app/models/congressperson'

def start
  Twitter.configure do |config|
    config.consumer_key = 'y0O3oTQZyXmRj8nr8lrVw'
    config.consumer_secret = 'OJ4Y7yNAOixRYdm2erPOELFjCZEcRdVjhiuPXZKTBX4'
    config.oauth_token = '110541321-iGnDagscx98KcwXcuYI6URaRKNgmZzIK8ExqyGdk'
    config.oauth_token_secret = 'uPn3PWr2C5Hhe3BjBgSpVZSGPrqUuyn10zxKQQDkAKjCU'
  end
end

def get_tweets(username, count=10)
  Twitter.user_timeline(username, count: 10)
end

 def add_tweets_to_db(legislator)
  tweets = get_tweets(legislator.twitter_id)
  tweets.each do |tweet|
    Tweet.create(content: tweet.text, tweet_id: tweet.attrs[:id],
                 tweeted_at: tweet.attrs[:created_at], congress_person: legislator)
  end
end

def seed
  start
  bad_ids = []
  #ActiveRecord::Base.connection
  CongressPerson.all.select { |cp|
    cp.twitter_id != "" && !already_seeded(cp.id)
  }.each do |cp|
    begin
      add_tweets_to_db(cp)
    rescue Twitter::Error::NotFound
      bad_ids << cp.twitter_id
    rescue Twitter::Error::Unauthorized
      bad_ids << cp.twitter_id
    end
  end
end

def already_seeded(cp_id)
  Tweet.find_by(congress_person_id: cp_id) == nil
end

seed
