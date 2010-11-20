class Poop < ActiveRecord::Base
  validates_presence_of :title, :code
  validates_inclusion_of :category_id, :in => Category.all.map(&:id), :message => "не выбрана"
  belongs_to :category

  scope :by_category, lambda { |category| where('category_id IN (?)', Category.find_by_name(category))}
end
