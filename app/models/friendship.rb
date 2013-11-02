class Friendship < ActiveRecord::Base
	belongs_to :user
	belongs_to :friend, :class_name => 'User'

	validates :user_id ,:presence => true
	validates :friend_id,:presence => true
	validates :status,:presence => true
	validate :user_exists
	validate :isnotsameperson


after_create :inverse_friendship
after_update :accept
after_destroy do |record| 
  other = Friendship.find_by_user_id_and_friend_id(record.friend_id, record.user_id)
  other.destroy if other
	end
#after_destroy :end_friendship
def isnotsameperson
	valid = self.user_id!=self.friend_id
	self.errors.add(:friend_id,'sorry') unless valid
end

def user_exists
	self.errors.add(:friend_id,'Person must exist') unless !User.find(self.friend_id).blank?
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
end
def inverse_friendship
	if self.status == 'pending'
	@a=User.find(self.friend_id).friendships.create(:user_id=>self.friend_id,:friend_id=>self.user_id,:status=>'requested')
	end
end

def ignore
	if self.status !=  'accepted'
		self.status='ignored'
	end
end
	


end