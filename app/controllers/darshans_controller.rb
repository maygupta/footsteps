class DarshansController < ApplicationController

  def index
    render :json => Darshan.all, :status => 200
  end

end