class MediasController < ApplicationController

  def index
    if params[:category].present?
      render :json => Medium.where(:category => params[:category]), :status => 200
    else
      render :json => Medium.all, :status => 200
    end
  end

end