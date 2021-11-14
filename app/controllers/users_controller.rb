class UsersController < ApplicationController
  get '/users' do
    User.all.to_json
  end

  post '/users' do
    User.add_user(username: params[:username], password: params[:password]).to_json
  end

  post '/login' do
    User.login(username: params[:username], password: params[:password]).to_json
  end
end