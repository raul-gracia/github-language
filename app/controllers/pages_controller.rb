class PagesController < ApplicationController
  def home
    @data = FavouriteLanguageService.for_user(params[:username]) if params[:username]
  end
end
