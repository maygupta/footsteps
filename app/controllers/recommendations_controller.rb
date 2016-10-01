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
        if params[:category].present?
          recs = recs.where(:is_entrepreneur => true)  if params[:category] == "entrepreneur"
          recs = recs.where(:is_higher_education => true)  if params[:category] == "higher_education"
        end
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
      if params[:debug].present?
        users.push({"emailAddress"=>"nsit.mayankgupta@gmail.com", "firstName"=>"Mayank", "lastName"=>"Gupta", "formattedName"=>"Mayank Gupta", "headline"=>"SDE3 at Groupon", "location"=>{"id"=>nil, "name"=>"New Delhi Area, India", "country"=>nil}, "industry"=>"software", "numConnections"=>"291", "numConnectionsCapped"=>"false", "summary"=>"Robotic Shera, mascot of CWGnResponsible for Control Systems. nFounding Member August 2010-October 2010nnAutonomous Underwater Vehicle DCEnhttp://www.auv.dce.edunResponsible for Embedded & Power Systems, Mechanical Systems. nMember July 2008 – PresentnnBharart Electronics Limitednhttp://www.bel-india.comnTrainee June - July 2010nnSociety for Robotronics DCEnWorkshops and Projects onEmbedded Systems.tnFounding Member Aug 2009 –PresentnnSpecialties: Embedded systems (8051 & 8085 Architecture).               nLinux/Unix, Windows Operating systemnPerl, CGI, Assembly language programming for 8051 & 8085, C.nNational Instruments Labview Graphical Programming Language  (G)nExtensive application level experience of 8051 architecture based microcontrollers.nInterfacing various sensors with a Personal Computer.nCircuit simulation using Orcad Capture & Pspice.", "positions"=>{"_total"=>1, "values"=>[{"id"=>"382286836", "title"=>"founder", "company"=>{"id"=>"2697", "industry"=>"Computer Software", "name"=>"Mentor Graphics", "size"=>"1001-5000", "type"=>"Public Company"}, "startDate"=>{"day"=>0, "month"=>1, "year"=>2012}, "endDate"=>nil, "isCurrent"=>true, "summary"=>"Product validation engineer for Veloce emulation system.", "location"=>{"id"=>nil, "name"=>"Noida Area, India", "country"=>nil}}]}, "pictureUrl"=>"https://media.licdn.com/mpr/mprx/0_vrCZ-33tuPZpts9rB-PI-CCPmn0grsBrRNnF-C8flvISfO8KJ9tNyGq38OxCPgnpN18QjLOlnUWt", "publicProfileUrl"=>"https://www.linkedin.com/in/amit-jain-20526929", "skills"=>{"_total"=>1, "values"=>[{"id"=>"14737898559781", "skill"=>{"name"=>"c++"}}]}, "loginType"=>"party_signup", "jid"=>"amitdce123##gmail.com@52.89.249.132", "imageUrl"=>"http://52.89.249.132:8080/images/amitdce123@gmail.com_SELECTION_DP_IMG_20160914_000400.jpg", "bgImageUrl"=>"http://52.89.249.132:8080/images/amitdce123@gmail.com_SELECTION_BG_IMG_20160914_000311.jpg", "firstTime"=>false, "mentor"=>false, "verified"=>false, "educations"=>{"_total"=>1, "values"=>[{"id"=>"e87dde5a-962b-4ebb-aae5-6f041fb798b8", "schoolName"=>"dav", "degree"=>nil, "startDate"=>{"day"=>0, "month"=>0, "year"=>2016}, "endDate"=>{"day"=>0, "month"=>0, "year"=>2016}, "fieldOfStudy"=>"12th", "grade"=>nil, "activities"=>nil, "notes"=>nil}]}})
      end
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
              re.is_higher_education = result[:is_higher_education]
              re.is_entrepreneur = result[:is_entrepreneur]
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
