class User < ActiveRecord::Base
  has_many :authorizations
  has_many :user_roles, :through => :authorizations
  has_many :employments ,:dependent => :destroy
  has_many :students, :dependent => :destroy
  belongs_to :country
  has_many :friends, :through => :friendships, :conditions => "status = 'accepted'"
  has_many :requested_friends, :through => :friendships, :source => :friend, :conditions => "status = 'requested'", :order => :created_at
  has_many :pending_friends, :through => :friendships, :source => :friend, :conditions => "status = 'pending'", :order => :created_at
  has_many :ignored_friends, :through => :friendships, :source => :friend, :conditions => "status = 'ignored'", :order => :created_at
  has_many :friendships, :dependent => :destroy



  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and , :registerable,
  devise :database_authenticatable, :registerable,:omniauthable,#,:confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable,:omniauth_providers => [:google_Oauth2]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :authentication_token, \
  :fname, :lname  ,:country,:postcode,:provider,:uid,:country_id#,:confirmed_at,:confirmation_sent_at,:confirmation_token
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
    return self.fname+" "+self.lname
  end

  def self.search(search)
    if search
      search =search.delete(' ');
      if Rails.env.production?
        where('fname LIKE ? or lname LIKE ? or fname||lname LIKE ?',  "%#{search}%","%#{search}%","%#{search}%")
      else
        where('fname LIKE ? or lname LIKE ? or concat(fname,lname) LIKE ?', "%#{search}%","%#{search}%","%#{search}%")
      end

    else
      find(:all)
    end
  end

  def self.advanced_search(first_name,last_name,company,school,country)


    @query='fname LIKE ? and lname LIKE ?  and (company  LIKE ? ';
    @query+=(company.blank? ? 'OR company IS ? )'  : ') '      ) + 'and (inst_name LIKE ?';
    @query+=(school.blank? ?  'or inst_name IS ? )' : ') ')   ;
    @query +=(Country.find_by_id(country).present? ? 'and country_id = ?' : '');

      if Country.find_by_id(country).present?

        User.joins('LEFT OUTER JOIN employments on users.id = employments.user_id LEFT OUTER JOIN students on users.id=students.user_id' )\
        .where(@query.to_s,"%#{first_name}%","%#{last_name}%"\
         ,"%#{company}%",(nil if company.blank?), "%#{school}%",(nil if school.blank?),country)
      else
      User.joins('LEFT OUTER JOIN employments on users.id = employments.user_id LEFT OUTER JOIN students on users.id=students.user_id')\
      .where(@query.to_s,"%#{first_name}%","%#{last_name}%"\
      ,"%#{company}%",(nil if company.blank?), "%#{school}%",(nil if school.blank?))
      end

    end
    #if Country.find_by_id(country).present?
    #  @temp=where('fname LIKE ? and lname LIKE ? and country_id = ?',"%#{first_name}%","%#{last_name}%",country)
    #else
    #  @temp=where('fname LIKE ? and lname LIKE ?',"%#{first_name}%","%#{last_name}%")
    #end

    #@temp.each do |s|
    # puts s.name
    #  if s.employments.where('company LIKE ?',"%#{company}%").any? || s.students.where('inst_name LIKE ?',"%#{school}%").any?
    #    @user.push(s)
    #  end
    #end




    def check_relation

    end
    def connect_with_person(friend_id,relation)

      @x=self.friendships.build(:friend_id=>friend_id,:relation=>relation)
      @x.status='pending'
      return @x
    end


    def connected_with(id)
      return self.friendships.find_by_friend_id(id).present?
    end

    def alumini(school,date_start,date_end)
      User.joins(' join students on students.user_id = users.id').\
      where('students.inst_name LIKE ? and start_date >= ? and end_date <= ? and users.id != ?',\
      "%#{school}%",date_start,date_end,self.id)
    end

    end
