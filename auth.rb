require 'sinatra'
require 'rest-client'
require 'json'

CLIENT_ID = File.read('client-id.token')
CLIENT_SECRET = File.read('client-secret.token')

def authenticate!
  redirect '/auth/create' if session[:token].nil?
end

get '/auth/create' do
  scopes = "repo read:user"
  redirect "https://github.com/login/oauth/authorize?scope=#{scopes}&client_id=#{CLIENT_ID}"
end

get '/auth/callback' do
  result = RestClient.post('https://github.com/login/oauth/access_token',
                          {client_id: CLIENT_ID,
                           client_secret: CLIENT_SECRET,
                           code: params[:code]},
                           accept: :json)

  result = JSON.parse(result)
  session[:token] = result["access_token"]

  redirect '/user'
end
