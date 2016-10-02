class BhaktiSangaDevotee < ActiveRecord::Base
  belongs_to :bhakti_sanga  # foreign key - bhakti_sanga_id
  belongs_to :devotee   # foreign key - devotee_id
end