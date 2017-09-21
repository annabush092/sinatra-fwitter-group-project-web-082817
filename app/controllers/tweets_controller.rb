class TweetsController < ApplicationController

  get '/tweets' do
    if session[:user_id]
      @user = User.find(session[:user_id])
    else
      redirect to '/login'
    end
    erb :'tweets/index'
  end

  get '/tweets/new' do
    if session[:user_id]
      @failed = session.delete(:failed)
      erb :'tweets/create_tweet'
    else
      redirect to '/login'
    end
  end

  post '/tweets/new' do
    @user = User.find(session[:user_id])
    if params[:content].length>0
      @user.tweets << Tweet.create(params)
      @user.save
      redirect to "/users/#{@user.slug}"
    else
      session[:failed] = true
      redirect to "/tweets/new"
    end
  end

  get '/tweets/:id' do
    @tweet = Tweet.find_by(id: params[:id])
    if session[:user_id] && !!@tweet
      erb :'tweets/show_tweet'
    else
      redirect to '/login'
    end
  end

  get '/tweets/:id/edit' do
    @tweet = Tweet.find_by(id: params[:id])
    #if previous attemt to edit failed, this is set to true
    @failed = session[:failed]

    #if tweet is found and the logged-in user = tweet's author, edit
    if !!@tweet && (session[:user_id]==@tweet.user.id)
        erb :'tweets/edit_tweet'
    #if a user tries to edit someone else's post, redirect to the tweets index
    elsif session[:user_id]
        redirect to '/tweets'
    #if logged out, redirect to /login
    else
      redirect to '/login'
    end
  end

  patch '/tweets/:id' do
    @tweet = Tweet.find(params[:id])
    if params[:content].length>0
      @tweet.update(content: params[:content])
      redirect to "/tweets/#{@tweet.id}"
    else
      session[:failed] = true
      redirect to "/tweets/#{@tweet.id}/edit"
    end
  end

  delete '/tweets/:id/delete' do
    @tweet = Tweet.find(params[:id])
    if session[:user_id] == @tweet.user.id
      @tweet.destroy
    else
      redirect to '/tweets'
    end
  end

end
