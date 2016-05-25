class UsersController < ApplicationController
	def show
		users = User.all
		render :json => users, status: 200
	end
end
