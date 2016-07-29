namespace :recommendations do

  desc "Generate Recommendations"
  task :generate => :environment do
    User.all.each do |first_user|
      User.all.each do |other_user|
        result = first_user.compare(other_user)
        Recommendation.create(:user_id => first_user.id, :preferences => result) if result[:is_mentor]
      end
    end
  end
end