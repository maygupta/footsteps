namespace :recommendations do

  desc "Generate Recommendations"
  task :generate => :environment do
    User.all.each do |first_user|
      existing = Recommendation.where(:user_id => first_user.id)
      User.all.each do |other_user|
        next if already_exists?(existing, other_user.id)
        result = first_user.compare(other_user)
        Recommendation.create(:user_id => first_user.id, :preferences => result) if result[:is_mentor]
      end
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
end