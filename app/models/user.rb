class User < ActiveRecord::Base
  has_many :authorizations
  has_many :user_roles, :through => :authorizations
  has_many :employments
  has_many :students
  belongs_to :country
  has_many :friends, :through => :friendships, :conditions => "status = 'accepted'"
  has_many :requested_friends, :through => :friendships, :source => :friend, :conditions => "status = 'requested'", :order => :created_at
  has_many :pending_friends, :through => :friendships, :source => :friend, :conditions => "status = 'pending'", :order => :created_at
  has_many :ignored_friends, :through => :friendships, :source => :friend, :conditions => "status = 'ignored'", :order => :created_at
  has_many :friendships#, :dependent => :destroy
  


  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and , :registerable,
  devise :database_authenticatable, :registerable,:omniauthable,#,:confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable,:omniauth_providers => [:google_Oauth2]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :authentication_token, :fname, :lname  ,:country,:postcode,:provider,:uid,:country_id#,:confirmed_at,:confirmation_sent_at,:confirmation_token
  alias_attribute :roles, :user_roles

  validates :fname, :presence => true
  validates :lname, :presence => true
    validate :country_exists 

  # Ensure the there is a auth token for all users, authorization will still be enforced
  before_save :ensure_authentication_token

  # Define user role methods
  def role?(role)
    role_names.include? role.to_s
  end

  def role_names
    roles.map(&:name)
  end

def country_exists
  valid  = Country.exists?(self.country_id)
  self.errors.add(:country, "Must Select One") unless valid || self.country_id.blank?
end



  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end

  def facebook
    @facebook ||= Koala::Facebook::API.new(oauth_token)
    block_given? ? yield(@facebook) : @facebook
  rescue Koala::Facebook::APIError => e
    logger.info e.to_s
    nil
  end
  
  def friends_count
    facebook { |fb| fb.get_connection("me", "friends").size }
  end



  def ensure_authentication_token!   
    reset_authentication_token! if authentication_token.blank?   
  end  

  def self.from_omniauth(auth)
    if user = User.find_by_email(auth.info.email)
      user.provider = auth.provider
      user.uid = auth.uid
      user
    else
      where(auth.slice(:provider, :uid)).first_or_create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.username = auth.info.name
        user.email = auth.info.email
        user.avatar = auth.info.image
      end
    end
  end

  def name
    self.fname +' '+self.lname
  end





end
