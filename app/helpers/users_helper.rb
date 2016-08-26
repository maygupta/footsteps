module UsersHelper

  COLLEGE_COEF = {
    :name => 1,
    :degree => 2,
    :field => 4
  }

  COMPANY_COEF = {
    :industry => 1,
    :name => 2,
    :role => 4,
    :position => 8
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
    experience_total_score = 0
    # 1. College match 
    education_match = []
    if user1["educations"].present? and user2["educations"].present?
      user1["educations"]["values"].each do |e1|
        user2["educations"]["values"].each do |e2|
          if e1["schoolName"] == e2["schoolName"]
            education_match.push(self.compare_college(e1, e2))
            experience_total_score += education_match.last[:score]
          end
        end
      end
    end

    # 2. Company match 
    comany_match = []
    if user1["positions"].present? and user2["positions"].present?
      user1["positions"]["values"].each do |e1|
        user2["positions"]["values"].each do |e2|
          if e1["company"]["industry"].present? and e1["company"]["industry"] == e2["company"]["industry"]
            comany_match.push(self.compare_company(e1, e2))
            experience_total_score += comany_match.last[:score]
          end
        end
      end
    end

    # 3. Skills match
    skills_match = []
    skills_total_score = 0
    if user1["skills"].present? and user2["skills"].present?
      user1["skills"]["values"].each do |s1|
        user2["skills"]["values"].each do |s2|
          if s1["skill"].present? and s1["skill"] == s2["skill"]
            skills_match.push({:skill => s1["skill"], :score => 1})
            skills_total_score += skills_match.last[:score]
          end
        end
      end
    end

    total_score = experience_total_score + skills_total_score
    {
      preferences: {
        :educations => education_match,
        :companies => comany_match,
        :skills => skills_match,
        :experience_total_score => experience_total_score,
        :skills_total_score => skills_total_score
      },
      score: total_score
    }

  end

  def self.compare_college(c1, c2)
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
    score = a * (x1 + x2*b + x3*c)
    {
      :name => c1["schoolName"],
      :score => score,
      :a => a,
      :b => b,
      :c => c
    }
  end

  def self.compare_company(c1, c2)
    p = 1
    if c1["company"]["name"].present? and c2["company"]["name"].present? and c1["company"]["name"] == c2["company"]["name"]
      q = 1
    else
      q = 0
    end
    if c1["title"].present? and c2["title"].present? and c1["title"] == c2["title"]
      r = 1
    else
      r = 0
    end

    s = 0

    y1 = COMPANY_COEF[:industry]
    y2 = COMPANY_COEF[:name]
    y3 = COMPANY_COEF[:role]
    y4 = COMPANY_COEF[:position]
    score = (p + q) * (y1 + y2 + y3*r + y4*s)
    {
      :industry => c1["industry"],
      :company => c1["company"]["name"],
      :score => score,
      :p => p,
      :q => q,
      :r => r,
      :s => s
    }
  end

end
