class Devotee < ActiveRecord::Base
  has_many :bhakti_sangas, through: :bhakti_sanga_devotees
  has_many :bhakti_sanga_devotees
end 