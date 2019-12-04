class MediasController < ApplicationController
  skip_before_filter :require_login

  def index
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    if params[:category].present?
      render :json => Medium.where(:category => params[:category]).order(id: :desc), :status => 200
    else
      render :json => Medium.order(id: :desc).all, :status => 200
    end
  end

  def search
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'

    ret = []
    if params[:query].present?
      Medium.where(:category => 'lecture').each do |m|
        if m.name.downcase().include? params[:query]
          ret.push(m)
        end
      end
    end

    render :json => ret, :status => 200

  end

end