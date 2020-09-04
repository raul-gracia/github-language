require 'rails_helper'

RSpec.describe FavouriteLanguageService do
  describe '#for_user' do
    it 'fetches and returns the user info' do
      expect_any_instance_of(GithubClientService).to receive(:user).with('raul-gracia').and_return({ username: 'raul-gracia' })

      VCR.use_cassette('user_info') do
        data = FavouriteLanguageService.for_user('raul-gracia')
        expect(data.keys).to include(:user_info)
        expect(data[:user_info]).to eq({ username: 'raul-gracia' })
      end
    end

    it 'fetches the list of repos' do
      expect_any_instance_of(GithubClientService).to receive(:repos).with('raul-gracia').and_return([{ 'name' => 'caesar_cipher' }])
      expect_any_instance_of(GithubClientService).to receive(:languages).with('raul-gracia', 'caesar_cipher').and_return({ 'Ruby' => 1 })

      VCR.use_cassette('repos_list') do
        data = FavouriteLanguageService.for_user('raul-gracia')
        expect(data.keys).to include(:languages)
        expect(data[:languages]).to eq(['Ruby'])
      end
    end

    it 'groups the languages together' do
      repos = [{ 'name' => 'repo1' }, { 'name' => 'repo2' }, { 'name' => 'repo3' }]
      expect_any_instance_of(GithubClientService).to receive(:repos).with('raul-gracia').and_return(repos)
      expect_any_instance_of(GithubClientService).to receive(:languages).with('raul-gracia', 'repo1').and_return({ 'Ruby' => 10, 'Elixir' => 3, 'Vue' => 29 })
      expect_any_instance_of(GithubClientService).to receive(:languages).with('raul-gracia', 'repo2').and_return({ 'Ruby' => 100, 'Elixir' => 300, 'Vue' => 32 })
      expect_any_instance_of(GithubClientService).to receive(:languages).with('raul-gracia', 'repo3').and_return({ 'Ruby' => 20, 'Elixir' => 8, 'Vue' => 112 })

      VCR.use_cassette('language_group') do
        data = FavouriteLanguageService.for_user('raul-gracia')
        expect(data.keys).to include(:languages)
        expect(data[:languages]).to eq(%w[Elixir Vue Ruby])
      end
    end
  end
end
