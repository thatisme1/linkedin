class Friendship < ActiveRecord::Base
	belongs_to :user
	belongs_to :friend, :class_name => 'User'

	validates :user_id ,:presence => true
	validates :friend_id,:presence => true
	validates :status,:presence => true
	validate :user_exists
	validate :isnotsameperson
  validate :not_already_present
  validate :check_relation

after_create :inverse_friendship

after_destroy do |record| 
  other = Friendship.find_by_user_id_and_friend_id(record.friend_id, record.user_id)
  other.destroy if other
	end
#after_destroy :end_friendship
def not_already_present
  if !self.id.blank?
  valid=self.id==Friendship.find_by_user_id_and_friend_id(self.user_id,self.friend_id).id
  else
  valid=valid||!Friendship.find_all_by_user_id_and_friend_id(self.user_id,self.friend_id).present?
  end
  self.errors.add(:friend_id,'Already connected') unless valid
end

def isnotsameperson
	valid = self.user_id!=self.friend_id
	self.errors.add(:friend_id,'sorry') unless valid
end

def user_exists
  if User.find_by_id(self.friend_id).blank?
	  self.errors.add(:friend_id,'Person must exist')
  end
end

def accept
	if self.status=='accepted'
		@abc=Friendship.find_by_user_id_and_friend_id(self.friend_id,self.user_id)
		if @abc && @abc.status!='accepted'
			@abc.status='accepted'
			@abc.save
		end
	end
end
def accept_request
	self.status='accepted'
	self.save
  self.accept
end
def inverse_friendship
	if self.status == 'pending'
	@a=User.find(self.friend_id).friendships.create(:user_id=>self.friend_id,:friend_id=>self.user_id,:status=>'requested',:relation=>self.relation)
	end
end

def ignore
	if self.status !=  'accepted'
		self.status='ignored'
    self.save
	end
end

def disconnect
  @u=Friendship.find_by_user_id_and_friend_id(self.friend_id,self.user.id)
  @u.destroy
  self.destroy
end

  def check_relation
    self.errors.add(:relation ,'Wrong Relation') unless self.relation=='Other'||self.relation=='Friend' || self.relation=='Acquaintance' ||self.relation=='Colleague' ||self.relation=='Classmate';

  end
end