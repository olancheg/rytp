require 'hpricot'

class Poop < ActiveRecord::Base
  attr_protected :rate
  belongs_to :category

  before_validation :prepare_code
  validates_presence_of :title
  validates_inclusion_of :category_id, :in => Category.all.map(&:id)
  validate :is_code_safe?
  before_save 'self.code = self.code.to_html'

  scope :by_category, lambda { |category| where('category_id IN (?)', Category.find_by_name(category)) }
  scope :by_category_id, lambda { |category_id| where('category_id = ?', category_id) }
  scope :ordered, order('created_at DESC')
  scope :approved, where('is_approved = ?', true)
  scope :rated, order('rate DESC').limit(50)
  scope :not_approved, where('is_approved = ?', false)
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

  def self.query_for_search_in(field, tags)
    ctags = tags.to_a.clone.map {|tag| '%'+tag.mb_chars.upcase+'%'}
    query = Array.new(tags.size).fill('upper(' + field.to_s + ')' + " LIKE ?").join ' OR '
    [ query, ctags ].flatten
  end

  def self.search(text)
    tags = text.to_s.mb_chars.split(/[,\.\/\\\'\":;\-_=\!\@\~\#\$\% ]/).uniq.delete_if{|tag| tag.length < 4 or tag.empty?}
    return [] if tags.empty?

    in_titles = self.query_for_search_in(:title, tags)
    in_descriptions = self.query_for_search_in(:description, tags)
    query = [in_titles.delete_at(0), in_descriptions.delete_at(0)].join ' OR '

    approved.where([query, in_titles, in_descriptions].flatten)
  end

  def self.ids(category_id)
    find_by_sql("SELECT id FROM poops WHERE is_approved IS TRUE AND category_id = " + category_id.to_s + "  ORDER BY created_at ASC")
  end
end

