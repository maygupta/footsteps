class MediasController < ApplicationController

  def index
    render :json => Medium.all, :status => 200
  end

end