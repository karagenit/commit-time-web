#!/usr/bin/env ruby

require 'sinatra'
require 'rest-client'
require 'json'

CLIENT_ID = File.read('client-id.token')
CLIENT_SECRET = File.read('client-secret.token')

get '/' do
  erb :index, locals: { client_id: CLIENT_ID, scopes: "repo read:user"}
end

get '/auth/callback' do
  github_code = params[:code]

  puts "Code: #{github_code}"

  result = RestClient.post('https://github.com/login/oauth/access_token',
                          {client_id: CLIENT_ID,
                           client_secret: CLIENT_SECRET,
                           code: github_code},
                           accept: :json)

  token = JSON.parse(result)['access_token']

  puts "Token: #{token}"
end
