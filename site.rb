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
  erb :user, locals: { repos: get_all_repos(session[:token], params[:login]) }
end
