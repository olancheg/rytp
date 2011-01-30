class Poop < ActiveRecord::Base
  validates_presence_of :title, :code
  validates_inclusion_of :category_id, :in => Category.all.map(&:id), :message => 'не выбрана'
  belongs_to :category

  scope :by_category, lambda { |category| where('category_id IN (?)', Category.find_by_name(category)) }
  scope :by_category_id, lambda { |category_id| where('category_id = ?', category_id) }
  scope :ordered, order('created_at DESC')
  scope :approved, where('is_approved = ?', true)
  scope :rated, where('rate > ?', 49)
  scope :not_approved, where('is_approved = ?', false)
  scope :popular, order('rate DESC').approved.rated

  attr_protected :rate

  def self.query_for_search_in(field, tags)
    ctags = tags.to_a.clone.map {|tag| '%'+tag.mb_chars.upcase+'%'}
    query = Array.new(tags.size).fill('upper(' + field.to_s + ')' + " LIKE ?").join ' OR '
    [ query, ctags ].flatten
  end

  def self.search(text)
    tags = text.to_s.split(/[,\.\/\\\'\":;\-_=\!\@\~\#\$ ]/).uniq.delete_if{|tag| tag.size < 3 or tag.empty?}
    return [] if tags.empty?

    in_titles = self.query_for_search_in(:title, tags)
    in_descriptions = self.query_for_search_in(:description, tags)
    query = [in_titles.delete_at(0), in_descriptions.delete_at(0)].join ' OR '

    where([query, in_titles, in_descriptions].flatten)
  end

  def self.ids(category_id)
    find_by_sql("SELECT id FROM poops WHERE is_approved IS TRUE AND category_id = " + category_id.to_s + "  ORDER BY created_at ASC")
  end
end
