class Contest < ActiveRecord::Base
  attr_accessible :name, :description, :start_at, :end_at

  has_many :poops

  validates_presence_of :name, :description
  validate :dates

  scope :active, where('contests.start_at <= ? AND contests.end_at >= ?', Date.today, Date.today)

  default_scope order('created_at DESC')

  def dates
    errors.add(:end_at, I18n.t(:'contest.wrong_dates')) if start_at >= end_at
  end

  def self.fetch_last
    active.limit(1).first
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end
end
