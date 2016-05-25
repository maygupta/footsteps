class SkillsController < ApplicationController

	def show
		skills = Skill.all
		render :json => skills, :status => 200

	end
end
