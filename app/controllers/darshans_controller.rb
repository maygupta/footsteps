class DarshansController < ApplicationController

  def index
    render :json => Darshan.order(id: :desc).all, :status => 200
  end

end