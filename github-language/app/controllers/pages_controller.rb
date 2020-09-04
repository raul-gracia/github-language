class PagesController < ApplicationController
  def home
    @user_info = FavouriteLanguageService.for_user(params[:username]) if params[:username]
  end
end
