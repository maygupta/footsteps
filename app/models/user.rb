class User < ActiveRecord::Base
	has_many :skills
	has_many :mentors, :class_name => 'User'
  has_many :positions

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

end
