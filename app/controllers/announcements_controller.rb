class AnnouncementsController < ApplicationController

  def index
    render :json => Announcement.all, :status => 200
  end

end