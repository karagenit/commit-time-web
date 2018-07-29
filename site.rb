#!/usr/bin/env ruby

require 'sinatra'

require_relative 'api/commit-time-github'

require_relative 'auth'
require_relative 'helpers'
require_relative 'queries'

enable :sessions

get '/' do
  erb :index
end

get '/user' do
  authenticate!

  # Used by search bar
  redirect "/user/#{params[:login]}" unless params[:login].nil?

  # Redirect to the authorized user's page
  session[:login] = get_login(session[:token])
  redirect "/user/#{session[:login]}"
end

get '/user/:login' do
  authenticate!
  populate_cache(session[:token], params[:login])
  erb :user, locals: { repos: read_cache(params[:login]) }
end

post '/user/:login/update' do
  update_cache(session[:token], params[:login])
  "Successfully Updated Cache!"
end
