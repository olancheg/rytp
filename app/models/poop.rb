require 'hpricot'

class Poop < ActiveRecord::Base
  attr_accessible :title, :description, :code, :approved, :category_id, :user_id

  PAGINATES_PER = 5

  include PgSearch
  pg_search_scope :search, :against => [:title, :description]

  paginates_per PAGINATES_PER

  belongs_to :category
  belongs_to :user, :counter_cache => true

  has_many :positive_votes, :class_name => "Vote", :conditions => {:positive => true}
  has_many :negative_votes, :class_name => "Vote", :conditions => {:positive => false}
  has_many :votes, :dependent => :destroy

  validates_presence_of :title
  validates_inclusion_of :category_id, :in => Category.ids
  validate :is_code_safe?

  before_validation :prepare_code
  before_save 'self.code = self.code.to_html'

  def prepare_code
    self.code = Hpricot.parse(self.code)
    self.code.search("*").collect!{ |node| node if node.name !~ /^iframe$/ }.compact.remove
  end

  def is_code_safe?
    iframes = (self.code/"iframe")
    src = iframes.first[:src] unless iframes.empty?

    errors.add(:code, I18n.t(:'wrong_code')) unless
        src =~ /^http\:\/\/(www\.)?(vk\.com|vkontakte\.ru|youtube\.com)/ and iframes.size == 1
  end

  default_scope includes(:category, :user)

  scope :by_category, lambda { |category| where(:category_id => Category.find_all_by_name(category)) }
  scope :by_category_id, lambda { |category_id| where(:category_id => category_id) }
  scope :ordered, order('created_at DESC')
  scope :back_ordered, order('created_at ASC')
  scope :approved, where(:approved => true)
  scope :not_approved, where(:approved => false)
  scope :rated, limit(50)
  scope :popular, approved.rated
  scope :feed, lambda { |category| ordered.approved.by_category(category || 'RYTP') }
  scope :top_by_category_and_period, lambda { |category, period| by_category(category || 'RYTP').by_period(period || '').popular }

  scope :filters_and_orders, lambda { |params|
                                      order((params[:sort_by] == 'date' ? 'created_at' : 'rating') + ' ' + (params[:order] || 'desc')).
                                      where(:approved => (params[:approved] != 'false'))
                                    }

  delegate :name, :to => :category, :prefix => true

  def to_param
    "#{id}-#{title.parameterize}"
  end

  def self.top(category, period, page)
    Kaminari.paginate_array(Poop.top_by_category_and_period(category, period).to_a).page(page).per(PAGINATES_PER)
  end

  def self.by_period(period)
    start = case period
            when 'by_month'
              1.month.ago
            when 'all_time'
              10.years.ago
            else
              1.week.ago
            end

    select('poops.*, count(votes.id) as vc').
    joins(:votes).
    where(:votes => {:created_at => start..Time.now}).
    group(Poop.columns.map{|c| "poops.#{c.name}"} * ', ').
    order('poops.rating DESC, vc DESC')
  end

  def self.poops_from_category(category_id)
    approved.by_category_id(category_id).back_ordered
  end

  def self.new_unapproved
    not_approved.count
  end
end
