class UsersController < ApplicationController
  get '/users' do
    p params
    User.all.to_json
  end

  get '/users/:id' do
    user = User.find_by(id: params[:id])
    User.current(login_token: params[:login_token]) == user ? user.to_json : {}.to_json
  end

  post '/users' do
    User.add_user(username: params[:username], password: params[:password]).to_json
  end

  get '/login' do
    User.login(username: params[:username], password: params[:password]).to_json
  end

  get '/users/:id/logout' do
    user = User.find_by(id: params[:id])
    if user && User.current(login_token: params[:login_token]) == user
      user.logout.to_json
    end
  end
end