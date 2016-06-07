class User < ActiveRecord::Base
	has_many :skills
	has_many :mentors, :class_name => 'User'
  has_many :positions

  include UsersHelper

  def self.create_user_from_linkedin(access_token)
    url = "https://api.linkedin.com/v1/people/"
    url += "~:(positions,summary,id,num-connections,picture-url,location,industry,specialties,headline,first-name,last-name)"
    url += "?format=json&oauth2_access_token=#{access_token}&format=json-get"
    response = Typhoeus.get(url)
    if response.success?
      body = JSON.parse response.body
      user = User.new
      user.access_token = access_token
      user.name = body["firstName"]
      user.last_name = body["lastName"]
      user.industry = body["industry"]
      user.picture_url = body["pictureUrl"]
      user.headline = body["headline"]
      user.city = body["location"]["name"]
      user.country = body["location"]["country"]["code"]
      user.positions = []

      body["positions"]["values"].each do |pos|
        new_pos = Position.new(
            :company_name => pos["company"]["name"],
            :company_id => pos["company"]["id"],
            :title => pos["title"],
            :is_current => pos["isCurrent"],
            :location_name => pos["location"]["name"]
          )
        if pos["startDate"].present?
          new_pos.start_month = pos["startDate"]["month"]
          new_pos.start_year = pos["startDate"]["year"]
        end
        if pos["endDate"].present?
          new_pos.end_month = pos["endDate"]["month"]
          new_pos.end_year = pos["endDate"]["year"]
        end
        new_pos.save
        user.positions.push(new_pos)
      end
      user.save
    else
      raise "There was an error connecting to Linked in #{response.error}"
    end
    user
  end

  def compare(other_user)
    match = {
      :is_mentor => false
    }

    match[:positions] = {
      :score => 0.0,
      :companies => []
    }
    
    self.positions.each do |pos|
      other_user.positions.each do |other_pos|
        if pos.company_name == other_pos.company_name
          match[:positions][:score] += 0.1
          match[:positions][:companies].push({
            :name => pos.company_name
          })
          match[:is_mentor] = true
        end
      end
    end

    match[:industry] = {
      :score => 0.0,
      :value => nil
    }

    if self.industry == other_user.industry
      match[:industry][:score] += 1.0
      match[:industry][:value] = self.industry
      match[:is_mentor] = true
    end

    return match
  end

  def get_recommendations
    UsersHelper.get_recommendations(self)
  end

end
