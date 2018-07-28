#!/usr/bin/env ruby

require 'sinatra'
require 'rest-client'
require 'json'

CLIENT_ID = File.read('client-id.token')
CLIENT_SECRET = File.read('client-secret.token')

get '/' do
  erb :index, locals: { client_id: CLIENT_ID, scopes: "repo read:user"}
end
