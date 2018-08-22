#!/usr/bin/env ruby

require 'sinatra'
require 'dotenv/load'

require_relative 'auth'
require_relative 'helpers'
require_relative 'api'
require_relative 'db'

configure do
  enable :sessions
end

get '/' do
  erb :index
end

get '/user' do
  authenticate!

  # Used by search bar
  redirect "/user/#{params[:login]}" unless params[:login].nil?

  # Redirect to the authorized user's page
  redirect "/user/#{get_login(session[:token])}"
end

get '/user/:login' do
  authenticate!
  erb :user, locals: { name: params[:login] }
end

post '/user/:login/read' do
  read_cache(params[:login])
end

# TODO: don't need to populate here, since /update is called when the page loads
#       so we know populate has already been called.
post '/user/:login/forceupdate' do
  populate_cache(session[:token], params[:login])
  force_update_cache(session[:token], params[:login])
  read_cache(params[:login])
end

post '/user/:login/update' do
  populate_cache(session[:token], params[:login])
  update_cache(session[:token], params[:login])
  read_cache(params[:login])
end

