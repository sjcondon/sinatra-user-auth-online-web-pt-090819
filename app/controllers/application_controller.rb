class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :views, Proc.new { File.join(root, "../views/") }

  configure do
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do
    erb :home
  end

  get '/registrations/signup' do # the sign-up form view. 

    erb :'/registrations/signup'
  end

  post '/registrations' do #responsible for handling the POST request that is sent when a user hits 'submit' on the sign-up form
    @user = User.new(name: params["name"], email: params["email"], password: params["password"])
    @user.save
    session[:user_id] = @user.id

    redirect '/users/home'
  end

  get '/sessions/login' do #responsible for rendering the login form.

    # the line of code below render the view page in app/views/sessions/login.erb
    erb :'sessions/login'
  end

  post '/sessions' do #responsible for receiving the POST request that gets sent when a user hits 'submit' on the login form
    @user = User.find_by(email: params[:email], password: params[:password])
    if @user
      session[:user_id] = @user.id
      redirect '/users/home'
    end
    redirect '/sessions/login'
  end

  get '/sessions/logout' do #responsible for logging the user out by clearing the session has
    session.clear
    redirect '/'
    session.clear
  end

  get '/users/home' do #rendering the user's homepage view.
    @user = User.find(session[:user_id])
    erb :'/users/home'
  end
end
