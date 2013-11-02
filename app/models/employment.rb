class Employment < ActiveRecord::Base
	belongs_to :user
	attr_accessible :title , :company ,:industry ,:start_date, :end_date,:user_id
	validates :title,:presence => true 
	validates :industry,:presence => true 
	validates :company,:presence => true 
	validates :start_date,:presence => true
	validates :end_date,:presence => true  
	validates :user_id,:presence => true  

end