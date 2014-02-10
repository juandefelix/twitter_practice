require 'pry'

get '/' do
  erb :index
end

post '/find' do
  TwitterUser.create(user_name: params[:handle])
  redirect "/#{params[:handle]}"
end

get '/:username' do
  @user = TwitterUser.find_by_user_name(params[:username])
  @tweets = @user.tweets.last(10).reverse.map{|x| x.content}
  erb :user_tweets
end

post '/username' do
  puts params
  @user = TwitterUser.find_by_user_name(params['userName'])
  @user.fetch_tweets!
  @tweets = @user.tweets.last(10).reverse.map{|x| x.content}
  @tweets.to_json
end
