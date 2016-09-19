class AnnouncementsController < ApplicationController

  def index
    render :json => Announcement.order(id: :desc).all, :status => 200
  end

end