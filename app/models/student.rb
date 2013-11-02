class Student < ActiveRecord::Base
	belongs_to :user

	attr_accessible :inst_name ,:start_date,:end_date,:description,:user_id

	validates :inst_name ,:presence=>'true'
	validates :start_date ,:presence=>'true'
	validates :end_date ,:presence=>'true'
	validates :user_id ,:presence=>'true'
	

end
