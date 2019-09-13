class SectionsController < ApplicationController
  skip_before_filter :require_login
  

  def index
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'

    ret = []

    Section.all.each do |section|
      ret.push({:section => section, :first_media => section.media.first, :first_darshan => section.darshan.first})
    end

    render :json => ret, :status => 200
  end

  def media
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    if params[:section_id].present?
      section = Section.find(params[:section_id])
    else
      return :json => {'message': 'missing section_id'}, :status => 404
    end
    
    @page = params[:page].present? ? params[:page] : 0
    render :json => section.media.where(:category => params[:category]).order(created_at: :desc).limit(10).offset(@page * 10).all, :status => 200
  end

  def darshan
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    if params[:section_id].present?
      section = Section.find(params[:section_id])
    else
      return :json => {'message': 'missing section_id'}, :status => 404
    end

    render :json => section.darshan.all, :status => 200
  end

end
