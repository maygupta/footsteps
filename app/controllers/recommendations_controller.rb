class RecommendationsController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  def index
    if !is_authorized?
      render :json => "Unauthorized", status: 422
      return
    end
    if params[:user_email].present?
      user = User.find_by_email(params[:user_email])
    elsif params[:user_id].present?
      user = User.find(params[:user_id])
    else
      render :json => "Unable to find user".to_json, :status => 404
    end

    recommendations_json = { 
      recommendations: get_recommendations(user, params[:page], params[:per_page])
    }.to_json
    render :json => recommendations_json, status: 200
        
  end

  private

  def get_recommendations(user, page = 1, per_page = 5)
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
