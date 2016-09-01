class AnnouncementsController < ApplicationController

  def index
    render :json => Announcement.all.reverse, :status => 200
  end

end