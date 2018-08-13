require File.expand_path '../spec_helper.rb', __FILE__

describe "My Sinatra Application" do
  it "should allow accessing the home page" do
    get '/'
    expect(last_response).to be_ok
  end

  it "should be able to get the user's login from their token" do
    token = File.read("api.token")
    expect(query_login(token)).to eq('karagenit')
  end

  it "should be able to query the API for a repo list" do
    token = File.read("api.token")
    repos = get_repo_list(token, 'karagenit')
    expect(repos.length).to be > 200
    expect(repos[0]).to_not be(nil)
  end

  it "should be able to query the API for a specific repo" do
    token = File.read('api.token')
    repo = get_repo(token, 'karagenit', 'homepage')
    expect(repo).to_not be(nil)
    expect(repo.total_time).to be > 60
  end
end
