class User < ActiveRecord::Base
	has_many :skills
	has_many :mentors, :class_name => 'User'
end
