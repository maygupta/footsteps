class Section < ActiveRecord::Base
  has_many :media
  has_many :darshan
end
