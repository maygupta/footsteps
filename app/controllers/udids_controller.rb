class UdidsController < ApplicationController

  skip_before_action :verify_authenticity_token


  def index
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'

    udids = Udid.all
    render :json => udids, :status => 200
  end


  def create
    @udid = Udid.new(:name => params[:udid])
    if @name.save
      msg = "UDID created successfully"
      render :json => {message: msg}, :status => 200
    else
      msg = "error"
      render :json => {message: msg}, :status => 500
    end
    
  end

end
