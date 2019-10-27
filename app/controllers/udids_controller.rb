class UDIDsController < ApplicationController

  def index
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'

    udids = UDID.all
    render :json => udids, :status => 200
  end


  def create
    @udid = UDID.new(:name => params[:udid])
    if @name.save
      msg = "UDID created successfully"
      render :json => {message: msg}, :status => 200
    else
      msg = "error"
      render :json => {message: msg}, :status => 500
    end
    
  end

end
