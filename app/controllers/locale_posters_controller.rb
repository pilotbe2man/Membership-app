class LocalePostersController < ApplicationController

  def create
    @poster  = LocalePoster.find(params[:locale_poster][:download_pdf])
    aws_path = @poster.poster.url
    data     = open(["http:", aws_path].join)
    send_data data.read, filename: @poster.poster.instance.poster_file_name, type: "application/pdf"
    user = PosterEmailUser.create(email: params[:user_email], locale_poster_id: params[:locale_poster][:download_pdf])

  end

end
