class UsersController < ApplicationController
	def show
		users = User.all
		render :json => users, status: 200
	end

  def get_or_create
    if params[:id].present?
      user = User.find(params[:id])
      if !user.present?
        access_token = params[:access_token]
        user = User.find_by_access_token(access_token)
        if !user.present?
          # Request user's info from LinkedIn and create user in database
          user = User.create_user_from_linkedin(access_token)
        end
      end
    end
    render :json => user.to_json, status: 200
  end

end
