require 'github/graphql'

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
