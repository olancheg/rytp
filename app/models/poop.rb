require 'hpricot'

class Poop < ActiveRecord::Base
  attr_accessible :title, :description, :code, :category_id, :contest_id

  PAGINATES_PER = 5

  paginates_per PAGINATES_PER

  belongs_to :category
  belongs_to :contest
  belongs_to :user, :counter_cache => true

  has_many :positive_votes, :class_name => "Vote", :conditions => {:positive => true}
  has_many :negative_votes, :class_name => "Vote", :conditions => {:positive => false}
  has_many :votes, :dependent => :destroy

  has_many :favourites, :dependent => :destroy

  validates_presence_of :title
  validates_inclusion_of :category_id, :in => Category.ids
  validate :code_safe?

  before_validation :prepare_code
  before_save 'self.code = self.code.to_html'

  def prepare_code
    self.code = Hpricot.parse(self.code)
    self.code.search("*").collect!{ |node| node if node.name !~ /^iframe$/ }.compact.remove
  end

  def code_safe?
    iframes = (self.code/"iframe")
    src = iframes.first[:src] unless iframes.empty?

    errors.add(:code, I18n.t(:'wrong_code')) unless
        src =~ /^http\:\/\/(www\.)?(vk\.com|vkontakte\.ru|youtube\.com)/ and iframes.size == 1
  end

  scope :not_participating_now, joins('LEFT OUTER JOIN contests ON contests.id = poops.contest_id').
                                where('poops.contest_id IS NULL OR contests.end_at < ?', Date.today)
  scope :by_category, lambda { |category| where(:category_id => Category.find_all_by_name(category)) }
  scope :by_category_id, lambda { |category_id| where(:category_id => category_id) }
  scope :without_contest, where(:contest_id => nil)
  scope :with_contest, where('contest_id > 0')
  scope :ordered, order('created_at DESC')
  scope :back_ordered, order('created_at ASC')
  scope :only_approved, where(:approved => true)
  scope :approved, only_approved.not_participating_now
  scope :not_approved, where(:approved => false)
  scope :rated, limit(50)
  scope :popular, approved.rated
  scope :feed, lambda { |category| ordered.approved.by_category(category || 'RYTP') }
  scope :top_by_category_and_period, lambda { |category, period| by_category(category || 'RYTP').by_period(period || '').popular.not_participating_now }

  default_scope includes(:category, :user)

  delegate :name, :to => :category, :prefix => true, :allow_nil => true

  def to_param
    "#{id}-#{title.parameterize}"
  end

  def self.top(category, period, page)
    Kaminari.paginate_array(Poop.top_by_category_and_period(category, period).to_a).page(page).per(PAGINATES_PER)
  end

  def self.search(text)
    return scoped unless text
    t = build_search_conditions(text, :title)
    d = build_search_conditions(text, :description)
    where((t[:query] + d[:query]) * ' OR ', *[t[:values] + d[:values]].flatten)
  end

  def self.fetch_last
    by_category('RYTP').approved.limit(1).last
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

  def name
    "#{rating} - #{title}"
  end

  private

  def self.build_search_conditions(text, field)
    words = text.split(/[,\.\/\\ \|\[\]-_={}\?]/).compact
    { :query => Array.new(words.size).fill("poops.#{field} ILIKE ?"), :values => words.map{|t| "%#{t}%"} }
  end
end
