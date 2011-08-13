class User < ActiveRecord::Base
  attr_accessible :name, :email, :nickname, :youtube_channel, :use_nickname_instead_of_name,
                  :show_profile_url, :profile_url, :roles_attributes

  PAGINATES_PER = 10

  include PgSearch
  pg_search_scope :search, :against => [:name, :email, :nickname]

  paginates_per PAGINATES_PER

  has_many :authentications
  has_many :poops
  has_many :news
  has_many :roles

  has_many :votes, :dependent => :destroy
  has_many :positive_votes, :class_name => "Vote", :conditions => {:positive => true}
  has_many :negative_votes, :class_name => "Vote", :conditions => {:positive => false}

  validates_presence_of :name
  validates_presence_of :nickname, :if => proc { use_nickname_instead_of_name? }

  after_save :create_default_role, :on => :create

  accepts_nested_attributes_for :roles, :allow_destroy => true, :reject_if => proc { |obj| obj.blank? }

  def self.create_from_hash!(hash)
    instance = new( :name => hash['user_info']['name'],
                    :email => hash['user_info']['email'],
                    :nickname => hash['user_info']['nickname'] )

    instance.set_default_profile_url(hash)
    instance.save
    instance
  end

  def to_s
    use_nickname_instead_of_name? ? nickname : name
  end

  def rating
    rating_positive - rating_negative
  end

  def rating_positive
    @rating_positive ||= Vote.positive.where(:poop_id => poops).count
  end

  def rating_negative
    @rating_negative ||= Vote.negative.where(:poop_id => poops).count
  end

  def rating_given_positive
    @rating_given_positive ||= positive_votes.count
  end

  def rating_given_negative
    @rating_given_negative ||= negative_votes.count
  end

  def has_role?(role)
    roles.any? { |r| r.mask == Role::LIST[role.to_sym] }
  end

  def set_default_profile_url(hash)
    provider = hash['provider']
    uid = hash['uid']
    nickname = hash['user_info']['nickname']

    self.profile_url = case provider
    when 'twitter'
      'http://twitter.com/' + nickname.to_s
    when 'facebook'
      'http://www.facebook.com/profile.php?id=' + uid.to_s
    when 'vkontakte'
      'http://vkontakte.ru/id' + uid.to_s
    else
      ''
    end
  end

  def create_default_role
    roles.create(:mask => Role::LIST[:user])
  end
end
