#!/usr/bin/env ruby

require 'sinatra'

require_relative 'auth'
require_relative 'helpers'
require_relative 'api'
require_relative 'db'

enable :sessions

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

post '/user/:login/update' do
  update_cache(session[:token], params[:login])
  read_cache(params[:login]).map do |repo|
    { name: repo[:name],
      total: repo[:times].total_time,
      commits: repo[:times].commits,
      average: repo[:times].average_time
    }
  end.to_json
end

post '/user/:login/populate' do
  populate_cache(session[:token], params[:login])
  read_cache(params[:login]).map do |repo|
     { name: repo[:name],
      total: repo[:times].total_time,
      commits: repo[:times].commits,
      average: repo[:times].average_time
    }
  end.to_json
end

