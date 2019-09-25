class Section < ActiveRecord::Base
  has_many :media
  has_many :darshan
  belongs_to :group
end
