class DarshansController < ApplicationController
	skip_before_filter :require_login
	

  def index
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    render :json => Darshan.order(id: :desc).all[0,10], :status => 200
  end

  def search
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'

    ret = []
    if params[:query].present?
      Group.all.each do |group|
        group.sections.each do |section|
          if section.darshan.count > 0 and group.name.downcase().include? params[:query]
            ret.push(group)
            break
          end
        end
      end
    end

    render :json => ret, :status => 200

  end

end