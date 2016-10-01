module UsersHelper

  COLLEGE_COEF = {
    :name => 4,
    :degree => 2,
    :field => 1
  }

  COMPANY_COEF = {
    :name => 8,
    :industry => 4,
    :role => 2,
    :position => 1
  }

  def self.get_recommendations(user, page = 1, per_page = 5)
    # recommendations = {
    #   :category => "role",
    #   :category_text => "role wise recommendations",
    #   :recommended_users => []
    # }
    # User.all.each do |other_user|
    #   result = user.compare(other_user)
    #   recommendations[:recommended_users].push(result) if result[:is_mentor]
    # end
    # recommendations
  end

  def self.calculate(user1, user2)
    begin
      experience_total_score = 0
      education_score = 0
      company_score = 0
      index = 0
      total_indexes = 0
      total_indexes = user1["educations"]["values"].count if user1["educations"].present? && user1["educations"]["values"].present?
      matched_records = []

      # 1. College match
      education_match = []
      is_higher_education = self.compare_educations(user1["educations"], user2["educations"])
      if user1["educations"].present? and user2["educations"].present?
        user1["educations"]["values"].each do |e1|
          user2["educations"]["values"].each do |e2|
            if e1["schoolName"] == e2["schoolName"]
              match = self.compare_college(e1, e2, 2*(total_indexes - index) )
              education_match.push(match[:name])
              education_score += match[:score]
            end
          end
          index += 1
        end
      end

      if education_match.count > 0
        matched_records.push({
          "field": "education",
          "score": education_score,
          "values": education_match       
        })
      end

      index = 0
      total_indexes = user1["positions"]["values"].count if user1["positions"].present? && user1["positions"]["values"].present?
      # 2. Company match 
      company_match = []
      is_entrepreneur = false
      if user1["positions"].present? and user2["positions"].present?
        is_entrepreneur = user2["positions"].to_s.downcase().include? "founder"
        user1["positions"]["values"].each do |e1|
          user2["positions"]["values"].each do |e2|
            if e1["company"]["industry"].present? and e1["company"]["industry"] == e2["company"]["industry"]
              match = self.compare_company(e1, e2, 2*(total_indexes - index) )
              company_match.push(match[:company])
              company_score += match[:score]
            end
          end
          index += 1
        end
      end

      if company_match.count > 0
        matched_records.push({
          "field": "experience",
          "score": company_score,
          "values": company_match       
        })
      end

      # 3. Skills match
      skills_match = []
      skills_total_score = 0
      if user1["skills"].present? and user2["skills"].present?
        user1["skills"]["values"].each do |s1|
          user2["skills"]["values"].each do |s2|
            if s1["skill"].present? and s1["skill"] == s2["skill"]
              skills_match.push(s1["skill"]["name"])
              skills_total_score += 1
            end
          end
        end
      end

      if skills_match.count > 0
        matched_records.push({
          "field": "skills",
          "score": skills_total_score,
          "values": skills_match
        })
      end

      experience_total_score = company_score + education_score
      category = "job"

      total_score = experience_total_score + skills_total_score
      {
        preferences: {
          :matched_records => matched_records,
          :experience_total_score => experience_total_score,
          :skills_total_score => skills_total_score
        },
        score: total_score,
        category: category,
        is_entrepreneur: is_entrepreneur,
        is_higher_education: is_higher_education
      }
    rescue => e
      Rails.logger.error e.message
    end

  end

  def self.compare_college(c1, c2, college_score)
    a = 1
    if c1["degree"].present? and c2["degree"].present? and c1["degree"] == c2["degree"]
      b = 1
    else
      b = 0
    end
    if c1["fieldOfStudy"].present? and c2["fieldOfStudy"].present? and c1["fieldOfStudy"] == c2["fieldOfStudy"]
      c = 1
    else
      c = 0
    end
    x1 = COLLEGE_COEF[:name]
    x2 = COLLEGE_COEF[:degree]
    x3 = COLLEGE_COEF[:field]
    score = college_score * (a*x1 + x2*b + x3*c)
    {
      :name => c1["schoolName"],
      :score => score,
    }
  end

  def self.compare_company(c1, c2, company_score)
    q = 1
    if c1["company"]["name"].present? and c2["company"]["name"].present? and c1["company"]["name"] == c2["company"]["name"]
      p = 1
    else
      p = 0
    end
    if c1["title"].present? and c2["title"].present? and c1["title"] == c2["title"]
      r = 1
    else
      r = 0
    end

    s = 0

    y1 = COMPANY_COEF[:name]
    y2 = COMPANY_COEF[:industry]
    y3 = COMPANY_COEF[:role]
    y4 = COMPANY_COEF[:position]

    score = company_score * (p*y1 + q*y2 + y3*r + y4*s)
    {
      :industry => c1["industry"],
      :company => c1["company"]["name"],
      :score => score,
    }
  end

  def self.compare_educations(e1, e2)

    if e1.nil? and e2.present?
      return true
    end

    if e1.present? and e2.present?
      e1_rank = self.get_education_rank(e1)
      e2_rank = self.get_education_rank(e2)
      if e1_rank > e2_rank
        return true
      end
    end

    false
  end

  def self.get_education_rank(education)
    max_rank = 100

    education["values"].each do |e|
      e_str = e.to_s.downcase()
      if e_str.include? "phd" or e_str.include? "doctorate"
        rank = 1
      elsif e_str.include? "master" or e_str.include? "mba" or e_str.include? "ms" or e_str.include? "m.s" or
        e_str.include? "m.b.a" or e_str.include? "mtech"
        rank = 2
      else
        rank = 3
      end
          
      max_rank = max_rank > rank ? rank : max_rank
    end
    max_rank
  end

end
