module UsersHelper

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

      recommendations
    end

end
