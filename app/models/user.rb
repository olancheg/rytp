class User < ActiveRecord::Base
  attr_accessible :name, :email, :nickname, :use_nickname_instead_of_name,
                  :show_profile_url, :profile_url, :youtube_channel

  PAGINATES_PER = 10

  paginates_per PAGINATES_PER

  has_many :authentications, :dependent => :destroy
  has_many :poops
  has_many :news

  has_many :role_associations, :dependent => :destroy
  has_many :roles, :through => :role_associations

  has_many :votes, :dependent => :destroy
  has_many :positive_votes, :class_name => "Vote", :conditions => {:positive => true}
  has_many :negative_votes, :class_name => "Vote", :conditions => {:positive => false}

  has_many :favourites, :dependent => :destroy
  has_many :favoured_poops, :source => :poop, :through => :favourites

  validates_presence_of :name
  validates_presence_of :nickname, :if => lambda { use_nickname_instead_of_name? }

  validates_format_of :youtube_channel, :with => URI::regexp(%w(http https)), :if => lambda { youtube_channel? }
  validates_format_of :profile_url, :with => URI::regexp(%w(http https)), :if => lambda { profile_url? }

  default_scope includes(:roles)

  after_create :create_default_role

  def self.search(text)
    where 'users.name ILIKE ? or users.nickname ILIKE ?', *[text, text].map{|t| "%#{t}%"}
  end

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

  def has_role?(name)
    cached_roles.any? {|role| role.name.to_sym == name.to_sym}
  end

  def cached_roles
    @roles ||= roles
  end

  def favoured?(poop)
    favoured_poops.include? poop
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

  def filters_and_orders(params)
    result = Poop.where(:user_id => self)

    case params[:filter]
    when 'favourites'
      result = favoured_poops
      result = result.approved if params[:id].to_i != id
    when 'not_approved'
      result = result.not_approved
    when 'contest'
      result = result.with_contest
      result = result.approved if params[:id].to_i != id
    else
      result = result.approved.without_contest
    end

    result.order((params[:sort_by] == 'date' ? 'created_at' : 'rating') + ' ' + (params[:order] == 'asc' ? 'asc' : 'desc'))
  end

  def create_default_role
    roles << Role.find_by_mask(Role::LIST[:user])
  end
end
