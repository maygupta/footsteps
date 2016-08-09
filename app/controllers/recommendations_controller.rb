class RecommendationsController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  def index
    if !is_authorized?
      render :json => "Unauthorized", status: 422
      return
    end

    begin
      if params[:user_email].present?
        user = User.find_by_email(params[:user_email])
      elsif params[:user_id].present?
        user = User.find(params[:user_id])
      else
        render :json => "Unable to find user".to_json, :status => 404
        return
      end

      recommendations_json = { 
        recommendations: get_recommendations(user, params[:page], params[:per_page])
      }.to_json
      render :json => recommendations_json, status: 200
    rescue => e
      Rails.logger.error "Unable to generate recommendations due to #{e.message}"
      render :json => [], status: 500
    end
  end

  def run
    begin
      User.all.each do |first_user|
        existing = Recommendation.where(:user_id => first_user.id)
        User.all.each do |other_user|
          next if already_exists?(existing, other_user.id)
          result = first_user.compare(other_user)
          Recommendation.create(:user_id => first_user.id, :preferences => result) if result[:is_mentor]
        end
      end
      render :json => "Successfully generated recommendations", status: 200
    rescue => e
      render :json => e.message.to_json, status: 500
    end
  end

  def already_exists?(existing, user_id)
    existing.each do |r|
      if r.preferences["user"]["id"] == user_id
        return true
      end
    end
    return false
  end

  private

  def get_recommendations(user, page = 1, per_page = 20)
    recommendations = {
        :category => "role",
        :category_text => "role wise recommendations",
        :recommended_users => []
      }
    if user.recommendations.present?
      results = Recommendation.where(:user_id => user.id).paginate(:page => page, :per_page => per_page).pluck(:preferences)

      recommendations[:recommended_users] = results
    end
    recommendations[:recommended_users].sort! {|a,b| b["total_score"] <=> a["total_score"] }
    recommendations
  end

end
