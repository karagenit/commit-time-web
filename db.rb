require 'github/graphql'
require 'commit-time'
require 'date'
require 'redis'

require_relative 'api'

#
# Important note about Redis#get: if the key doesn't exist
# in the DB, it will return nil, but if the key was added
# with Redis.set(key, nil), it will return "" (empty string)
#

##
# For each repo contributed to by :login, update repo info
#
def force_update_cache(token, login)
  redis = Redis.new
  authorID = query_id(token, login)

  redis.keys("#{login}:*/*").each do |key|
    owner, name = key.split(':', 2)[1].split('/', 2)
    redis.set key, Marshal.dump(get_repo(token, owner, name, authorID))
  end
end

##
# For each repo contributed to by :login that has no info, get repo info
#
def update_cache(token, login)
  redis = Redis.new
  authorID = query_id(token, login)

  redis.keys("#{login}:*/*").each do |key|
    if redis.get(key).empty?
      owner, name = key.split(':', 2)[1].split('/', 2)
      redis.set key, Marshal.dump(get_repo(token, owner, name, authorID))
    end
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
    if redis.get(keyname).nil?
      redis.set keyname, nil
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
    begin
      { name: fullname, times: Marshal.load(redis.get(key)) }
    rescue Error
      { name: fullname, times: nil }
      # TODO: Could we just next or nil here and then repos.compact! later?
      # Is there any case where we would serialize a nil object into redis?
    end
  end
  repos.reject! { |repo| repo[:times].nil? }
  repos.map! do |repo|
    { name: repo[:name],
      total: repo[:times].total_time,
      commits: repo[:times].commits,
      average: repo[:times].average_time
    }
  end
  repos.to_json
end
