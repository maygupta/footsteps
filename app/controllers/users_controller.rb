class UsersController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  def index 
    if !is_authorized?
      render :json => "Unauthorized", status: 422
      return
    end
    response = Typhoeus.get("http://52.89.249.132:8080/QuickConnect-0.0.1/users",
        headers: { 'Content-Type' => "application/json"})
    users = JSON.parse(response.body)
    render :json => users.to_json, status: 200
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

  def update
    if !is_authorized?
      render :json => "Unauthorized", status: 422
      return
    end

    user = User.find(params[:id])
    if user.present?
      user.update_attributes(user_params)
      render :json => user.to_json, status: 200
    else
      render :json => "User not found", status: 404
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
      render :json => [], status: 200
    rescue => e
      Rails.logger.error "Unable to generate mentors recommendations due to #{e.message}"
      render :json => [], status: 200
    end
  end

  private

  def user_params
    params.require(:user).permit(:maiden_name,:formatted_name,:phonetic_first_name,
      :phonetic_last_name,:formatted_phonetic_name,:num_connections,:num_connections_capped,
      :specialties,:public_profile_url,:last_modified_timestamp,:proposal_comments,
      :interests,:languages,:date_of_birth,:jid,:login_type,:gender,:bg_image_url,
      :presence_status,:is_mentor,:is_verified,:mentor_rating,:normal_rating)
  end

end
