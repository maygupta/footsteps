class RecommendationsController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  include UsersHelper

  def index
    if !is_authorized?
      render :json => "Unauthorized", status: 422
      return
    end

    begin
      if params[:user_email].present?
        recs = NewRecommendation.where(:user_email => params[:user_email])
        recs = recs.where(:category => params[:category]) if params[:category].present?
        render :json => recs.paginate(:page => page, :per_page => per_page), status: 200 
      else
        render :json => "User not found", status: 200 
      end
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

  def run_new
    begin 
      response = Typhoeus.get("http://52.89.249.132:8080/QuickConnect-0.0.1/users",
        headers: { 'Content-Type' => "application/json"})
      users = JSON.parse(response.body)
      users.each do |first_user|
        users.each do |other_user|
          begin
            if first_user["emailAddress"] == other_user["emailAddress"]
              NewRecommendation.where(:user_email => first_user["emailAddress"], 
                :mentor_email => other_user["emailAddress"]).destroy_all
              next
            end
            result = UsersHelper.calculate(first_user, other_user)

            if result[:score] > 0
              re = NewRecommendation.find_or_create_by(
                :user_email => first_user["emailAddress"],
                :mentor_email => other_user["emailAddress"])


              re.preferences = result[:preferences]
              re.score = result[:score]
              re.category = result[:category]
              re.save
            end
          rescue => e
            Rails.logger.error(e.message)
          end
        end
      end
      render :json => {:recommendations => NewRecommendation.all.select(:id, :score, :mentor_email, "preferences as score_details")}, status: 200
    rescue => e
      render :json => e.message.to_json, status: 500
    end
  end

  def show_recs

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

  def page
    params[:page] || 1
  end

  def per_page
    params[:per_page] || 20
  end

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
