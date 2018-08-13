require 'github/graphql'
require 'commit-time'
require 'date'
require 'redis'

require_relative 'api'

##
# Force update cache from Github API
#
def update_cache(token, login)
  redis = Redis.new
  repos = get_repo_list(token, login)

  repos.each do |repo|
    keyname = login + ':' + repo[:owner] + '/' + repo[:name]
    ct = get_repo(token, repo[:owner], repo[:name], author: login)
    redis.set(keyname, Marshal.dump(ct)) # no nil check
  end
end

##
# Fill cache with repos from API that we don't have stored
#
def populate_cache(token, login)
  redis = Redis.new
  repos = get_repo_list(token, login)

  repos.each do |repo|
    keyname = login + ':' + repo[:owner] + '/' + repo[:name]
    if redis.get(keyname).nil? # TODO: what if it deserializes to NilClass?
      ct = get_repo(token, repo[:owner], repo[:name], author: login)
      redis.set(keyname, Marshal.dump(ct))
    end
  end
end

##
# Reads the list of commit-times from the Redis cache
#
def read_cache(login)
  redis = Redis.new
  repos = redis.keys("#{login}:*/*").map do |key|
    _, fullname = key.split(':', 2)
    { name: fullname, times: Marshal.load(redis.get(key)) }
  end
  repos.reject { |repo| repo[:times].nil? }
end
