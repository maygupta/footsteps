class SadhnaCard < ActiveRecord::Base
	belongs_to :user
	has_many :sadhna_card_books
end
