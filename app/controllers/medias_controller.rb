class MediasController < ApplicationController

  def index
    if params[:category].present?
      render :json => Medium.where(:category => params[:category]).order(id: :desc), :status => 200
    else
      render :json => Medium.order(id: :desc).all, :status => 200
    end
  end

end