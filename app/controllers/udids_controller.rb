class UdidsController < ApplicationController

  skip_before_action :verify_authenticity_token
  skip_before_filter :require_login


  def index
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'

    udids = Udid.all
    render :json => udids, :status => 200
  end


  def create
    @udid = Udid.new
    @udid.name = params[:udid]
    if @udid.save
      msg = "UDID created successfully"
      render :json => {message: msg}, :status => 200
    else
      msg = "error"
      render :json => {message: msg}, :status => 500
    end
    
  end

end
