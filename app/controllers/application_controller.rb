require_relative '../../config/environment'
class ApplicationController < Sinatra::Base
  configure do
    set :views, Proc.new { File.join(root, "../views/") }
    enable :sessions unless test?
    set :session_secret, "secret"
  end

  get '/' do
    erb :index
  end
  
  get '/registrations/signup' do
    erb :'/registrations/signup'
  end

  post '/registrations' do
    @user = User.new(name: params["name"], email: params["email"], password: params["password"])
    @user.save
    session[:user_id] = @user.id
    
    redirect '/users/home'
  end
  
  get '/sessions/login' do
    erb :'sessions/login'
  end
  
  post '/sessions' do
    @user = User.find_by(email: params[:email], password: params[:password])
    if @user
      session[:user_id] = @user.id
      redirect '/users/home'
    end
    redirect '/sessions/login'
  end
  
  get '/sessions/logout' do
    session.clear
    redirect '/'
  end
  
  get '/users/home' do
    @user = user.fin(session[:user_id])
    erb :'/users/home'
  end
end