require 'github/graphql'
require 'redis'

def get_login(token)
  query = %{
    query {
      viewer {
        login
      }
    }
  }

  result = Github.query(token, query)

  result.dig("data", "viewer", "login")
end

def get_repos(token, login)
  redis = Redis.new
  repos = get_repo_list(token, login)

  puts "Repos: #{repos.count}"

  values = repos.map do |repo|
    fullname = repo[:owner] + '/' + repo[:name]
    data = { name: fullname, times: nil }

    blob = redis.get(fullname)

    if !blob.nil?
      data[:times] = Marshal.load(blob) # TODO: exception check
      data
    else
      repo = get_repo(token, repo[:owner], repo[:name], author: login)
      data[:times] = repo
      redis.set(fullname, Marshal.dump(repo)) # TODO: handle errors
      data
    end
  end

  puts "Values: #{values.count}"

  values.reject { |val| val[:times].nil? }
  # TODO: we could allow nil objects (or maybe empty CommitTime objs?), and simply
  # check for that when we render, e.g.: repo.dig("times")&.total_time.to_i
end

