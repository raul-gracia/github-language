class GithubClientService
  def initialize(_user, token)
    @client = Octokit::Client.new(access_token: token)
  end

  def user(username)
    @client.user(username)
  end

  def repos(username)
    @client.repos(username)
  end

  def languages(username, repo)
    @client.languages("#{username}/#{repo}")
  end
end
