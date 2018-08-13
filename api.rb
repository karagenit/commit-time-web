require 'github/graphql'
require 'commit-time'
require 'date'
require 'redis'

##
# Gets the current session login or queries from the API
#
def get_login(token)
  if session[:login].nil?
    session[:login] = query_login(token)
  end
  session[:login]
end

##
# Queries the Github API for the login of the owner of the session token
#
def query_login(token)
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

##
# Returns a CommitTime object from a given Github repo.
# Commits are filtered such that only those authored by :author (which is,
# by default, equal to :user) are saved. Passing "" for :author will *jankily*
# calculate times for all users.
#
def get_repo(token, owner, repo, author = owner)
  query = %{
    query ($owner: String!, $repo: String!, $cursor: String) {
      repository(owner: $owner, name: $repo) {
        defaultBranchRef {
          target {
            ... on Commit {
              history(first: 100, after: $cursor) {
                edges {
                  node {
                    author {
                      user {
                        login
                      }
                    }
                    authoredDate
                  }
                }
                pageInfo {
                  hasNextPage
                  endCursor
                }
              }
            }
          }
        }
      }
    }
  }

  vars = { owner: owner, repo: repo, cursor: nil }

  commits = []

  loop do
    result = Github.query(token, query, vars)
    edges = result.dig('data', 'repository', 'defaultBranchRef', 'target', 'history', 'edges')
    info = result.dig('data', 'repository', 'defaultBranchRef', 'target', 'history', 'pageInfo')

    commits += edges || []
    break unless info.dig('hasNextPage')
    vars[:cursor] = info.dig('endCursor')
  end

  # Empty repo with no commits or default branch
  return nil if commits.nil?

  commits.select! { |e| e.dig("node", "author", "user", "login") == author }
  dates = commits.map { |e| e.dig("node", "authoredDate") }
  dates.map! { |date| DateTime.parse(date) }

  CommitTime.new(dates)
end

##
# Get a list of repositories for the given user
#
def get_repo_list(token, user)
  query = %{
    query ($user: String!, $cursor: String) {
      user(login: $user) {
        repositories(first: 100, after: $cursor) {
          edges {
            node {
              name
              owner {
                login
              }
            }
          }
          pageInfo {
            hasNextPage
            endCursor
          }
        }
      }
    }
  }

  vars = { user: user, cursor: nil }

  repos = []

  loop do
    result = Github.query(token, query, vars)
    repos += result.dig("data", "user", "repositories", "edges") || []
    break unless result.dig("data", "user", "repositories", "pageInfo", "hasNextPage")
    vars[:cursor] = result.dig("data", "user", "repositories", "pageInfo", "endCursor")
  end

  repos.map { |e| { owner: e.dig("node", "owner", "login"), name: e.dig("node", "name") } }
end
