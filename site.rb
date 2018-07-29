#!/usr/bin/env ruby

require 'sinatra'

require_relative 'api/commit-time-github'

require_relative 'auth'
require_relative 'helpers'

enable :sessions

get '/' do
  erb :index
end

get '/user' do
  authenticate!
  redirect "/user/#{params[:login]}" unless params[:login].nil?

  # TODO: redirect to /user/login based on who owns this OAuth token
  erb :search
end

get '/user/:login' do
  authenticate!
  erb :user, locals: { repos: get_all_repos(session[:token], params[:login]) }
end
