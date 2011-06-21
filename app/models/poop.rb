require 'hpricot'

class Poop < ActiveRecord::Base
  attr_protected :rate
  belongs_to :category

  before_validation :prepare_code
  validates_presence_of :title
  validates_inclusion_of :category_id, :in => Category.all.map(&:id)
  validate :is_code_safe?
  before_save 'self.code = self.code.to_html'
  
  include PgSearch
  pg_search_scope :search, :against => [:title, :description, :author]

  scope :by_category, lambda { |category| where('category_id IN (?)', Category.find_by_name(category)) }
  scope :by_category_id, lambda { |category_id| where('category_id = ?', category_id) }
  scope :ordered, order('created_at DESC')
  scope :back_ordered, order('created_at ASC')
  scope :approved, where('is_approved = ?', true)
  scope :not_approved, where('is_approved = ?', false)
  scope :rated, order('rate DESC').limit(50)
  scope :popular, order('rate DESC').approved.rated

  def prepare_code
    self.code = Hpricot.parse(self.code)
    self.code.search("*").collect! { |node| node if not node.name =~ /^iframe$/ }.compact.remove
  end

  def is_code_safe?
    iframes = (self.code/"iframe")
    src = iframes.first[:src] unless iframes.empty?

    errors.add(:code, I18n.t(:'wrong_code')) unless
        src =~ /^http\:\/\/(www\.)?(vk\.ru|vkontakte\.ru|youtube\.com|player.vimeo\.com)/ and iframes.size == 1
  end

  def self.ids_from_category(category_id)
    approved.by_category_id(category_id).back_ordered.map(&:id)
  end
end

