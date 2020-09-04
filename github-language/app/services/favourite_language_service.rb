class FavouriteLanguageService
  def initialize(client)
    @client = client
  end

  def self.for_user(username)
    client = GithubClientService.new(ENV['GITHUB_USER'], ENV['GITHUB_TOKEN'])
    new(client).for_user(username)
  end

  def for_user(username)
    @username = username
    languages = repos_list.map do |repo|
      Concurrent::Promise.execute do
        @client.languages(username, repo)
      end
    end
    languages = languages.map(&:value!)

    { user_info: user_info, languages: group_languages(languages) }
  rescue StandardError => e
    puts e
    nil
  end

  private

  def user_info
    @client.user(@username)
  end

  def repos_list
    @client.repos(@username).map { |repo| repo['name'] }
  end

  def group_languages(langs)
    languages_tally = Hash.new(0)
    langs.each do |lang|
      lang.each do |name, lines|
        languages_tally[name] += lines
      end
    end
    languages_tally.sort_by { |_k, v| v }.reverse.map(&:first)
  end
end
