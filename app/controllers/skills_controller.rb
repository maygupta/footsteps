class SkillsController < ApplicationController

	def index
		skills = Skill.all
		render :json => skills, :status => 200
	end

	def show
		skill = Skill.find(params[:id])
		render :json => skill, :status => 200
	end
end
