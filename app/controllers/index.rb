get '/' do
  erb :index
end

post '/find' do
  TwitterUser.create(user_name: params[:handle])
  redirect "/#{params[:handle]}"
end

get '/:username' do
  @user = TwitterUser.find_by_user_name(params[:username])
  if @user.tweets.empty?
    @user.fetch_tweets!
  end

  @tweets = @user.tweets.limit(10)
  erb :user_tweets
end
