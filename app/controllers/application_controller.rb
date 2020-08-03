require "./config/environment"
require "./app/models/user"

class ApplicationController < Sinatra::Base

  configure do
    set :method_override, true
    set :views, "app/views"
    enable :sessions
    set :session_secret, "un-hackable-secret"
  end

  get "/" do
    erb :index
  end

  get "/signup" do
    erb :'users/signup'
  end

  post "/signup" do
    binding.pry
    if params[:username].empty? || params[:password].empty? || User.exists?(username: params[:username])
      redirect '/failure'
    else
      User.create(username: params[:username],password: params[:password])
      redirect '/login'
    end
  end

  get '/home' do
    @user = User.find(session[:user_id])
    erb :home
  end

  get "/login" do
    erb :'users/login'
  end

  post "/login" do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect to "/home"
    else
      redirect to "/failure"
    end
  end

  get "/failure" do
    erb :'users/failure'
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  get "/new" do
    erb :'/tasks/new'
  end

  post "/show" do
    @task = current_user.tasks.create(name: params[:name], due_date: params[:due_date], description: params[:description])
    redirect '/home'
  end

  get '/show' do
    erb :'/tasks/show'
  end

  get '/tasks/:id/edit' do
    @task = current_user.tasks.find_by_id(params[:id])
    erb :'tasks/edit'
  end

  get '/test' do
    erb :'tasks/test'
  end

  patch '/tasks/:id' do #updating
    @task = current_user.tasks.find_by_id(params[:id])
    @task.update(
      name: params[:name], 
      due_date: params[:due_date], 
      description: params[:description]
    )
    redirect to "/show"
  end

  delete '/tasks/:id' do #Doesnt seem to delete the item fully?
    @task = current_user.tasks.find_by_id(params[:id])
    @task.delete
    redirect to '/show'
  end
 
  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
