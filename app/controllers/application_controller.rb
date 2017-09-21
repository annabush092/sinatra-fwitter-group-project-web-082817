require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do
    erb :index
  end

  get '/signup' do
    #check if logged in. If yes, redirect to /tweets
    if session[:user_id]
      redirect to "/tweets"
    end
    erb :'users/create_user'
  end

  post '/signup' do
    if params[:username].length>0 && params[:email].length>0 && params[:password].length>0
      @user = User.create(params)
      #start session/login
      session[:user_id] = @user.id
      redirect to "/tweets"
    else
      redirect to "/signup"
    end
  end

  get '/login' do
    #check if logged in. If yes, redirect to /tweets
    if session[:user_id]
      redirect to "/tweets"
    end
    #check if previous login failed (if true, display error message. If nil, don't)
    @failed = session.delete(:failed)
    erb :'users/login'
  end

  post '/login' do
    @user = User.find_by(params)
    #if a matching user was found, login user
    if @user
      session[:user_id] = @user.id
      redirect to '/tweets'
    else
      session[:failed] = true
      redirect to '/login'
    end
  end

  get '/logout' do
    #if someone is logged in, log them out
    if session[:user_id]
      session.delete(:user_id)
      redirect to '/login'
    else
      redirect to '/'
    end
  end

end
