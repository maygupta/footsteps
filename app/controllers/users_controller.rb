class UsersController < ApplicationController

  def index 
    users = User.all
    render :json => users, status: 200
  end

	def show
		user = User.find params[:id]
		render :json => user, status: 200
	end

  def add_skills
    params[:skills].each do |skill|
      skill_record = Skill.find_by_name(skill)
      if !skill_record.present?
        skill_record = Skill.create(:name => skill)
      end
      user.skills.push(skill_record)
    end
  end

  def get_or_create
    if params[:id].present?
      user = User.find(params[:id])
      render :json => user.to_json, status: 200 if user.present?
      return
    end

    access_token = params[:access_token]
    user = User.find_by_access_token(access_token)
    if !user.present?
      # Request user's info from LinkedIn and create user in database
      user = User.create_user_from_linkedin(access_token)
    end
    render :json => user.to_json, status: 200
  end

  def positions
    user = User.find params[:id]
    if user.present?
      render :json => user.positions.to_json, status: 200
    else
      render :json => [], status: 200
    end
  end

  def mentors
    begin
      user = User.find params[:id]
      if user.present?
        recommendations = user.get_recommendations
        render :json => {recommendations: recommendations}.to_json, status: 200
      else
        render :json => [], status: 200
      end
    rescue => e
      Rails.logger.error "Unable to generate mentors recommendations due to #{e.message}"
      render :json => [], status: 200
    end
  end

end
