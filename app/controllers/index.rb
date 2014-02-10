get '/' do
  erb :index
end

post '/find' do
  TwitterUser.create(user_name: params[:handle])
  redirect "/#{params[:handle]}"
end

get '/:username' do
  @user = TwitterUser.find_by_user_name(params[:username])
  @user.fetch_tweets!

  @tweets = @user.tweets.last(10).reverse
  erb :user_tweets
end
