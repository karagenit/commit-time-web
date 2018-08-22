require File.expand_path '../spec_helper.rb', __FILE__

require 'dotenv/load'

# TODO: helper script to create api.token
# TODO: don't hardcode 'karagenit', load from config file?
# TODO: make API-based tests optional (for speed)
# TODO: only run api tests if api.token is present
# TODO: use mock api queries (which just return hardcoded repo stats/repo lists for testing
#       update_cache etc.
# TODO: load tokens etc in a :before hook
# TODO: use different redis store for tests, and wipe before tests!

describe "My Sinatra Application" do
  it "should allow accessing the home page" do
    get '/'
    expect(last_response).to be_ok
  end

  it "should be able to get the user's login from their token" do
    expect(query_login(ENV["API_TOKEN"])).to eq('karagenit')
  end

  it "should be able to get a user's github ID tag" do
    expect(query_id(ENV["API_TOKEN"], 'karagenit')).to_not eq(nil)
  end

  it "should be able to query the API for a repo list" do
    repos = get_repo_list(ENV["API_TOKEN"], 'karagenit')
    expect(repos.length).to be > 200
    expect(repos[0]).to_not be(nil)
  end

  it "should be able to query the API for a specific repo" do
    authorID = query_id(ENV["API_TOKEN"], 'karagenit')
    repo = get_repo(ENV["API_TOKEN"], 'karagenit', 'homepage', authorID)
    expect(repo).to_not be(nil)
    expect(repo.total_time).to be > 60
  end

  it "should load the user page when session[:token] is set" do
    env 'rack.session', { token: ENV["API_TOKEN"] }
    get '/user/karagenit'
    expect(last_response).to be_ok
  end

  it "should redirect to the user's homepage when authenticated" do
    env 'rack.session', { token: ENV["API_TOKEN"] }
    get '/user'
    expect(last_response.status).to eq(302)
    expect(last_response.original_headers['Location']).to end_with('/user/karagenit')
  end

  # TODO: specs for get_repo and get_repo_list

  # TODO: test for redirect to Github when session[:token] is nil
end
