class PosterEmailUsersController < ApplicationController
  def index
    @posters = PosterEmailUser.where(locale_poster_id: params[:locale_poster_id])
     respond_to do |format|
      format.csv
    end
  end
end
