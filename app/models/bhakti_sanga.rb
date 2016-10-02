class BhaktiSanga < ActiveRecord::Base
  has_many :devotees, through: :bhakti_sanga_devotees
  has_many :bhakti_sanga_devotees
end