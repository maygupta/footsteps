module UsersHelper

    def self.get_recommendations(user)
      recommendations = []
      User.all.each do |other_user|
        result = user.compare(other_user)
        recommendations.push(result) if result[:is_mentor]
      end
      recommendations
    end

end
