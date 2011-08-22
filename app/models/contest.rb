class Contest < ActiveRecord::Base
  attr_accessible :name, :description, :start_at, :end_at

  PAGINATES_PER = 5

  paginates_per PAGINATES_PER

  has_many :poops

  validates_presence_of :name, :description
  validate :dates

  scope :active, where('contests.start_at <= ?', Date.today)
  scope :active_now, active.where('contests.end_at >= ?', Date.today)

  default_scope order('end_at DESC').includes(:poops)

  def to_s
    name
  end

  def dates
    errors.add(:end_at, I18n.t(:'contest.wrong_dates')) if start_at >= end_at
  end

  def self.fetch_last
    active.limit(1).first
  end

  def approved_poops(admin=false)
    Poop.unscoped do
      if admin
        poops
      else
        poops.only_approved
      end
    end
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end

  def active?
    start_at <= Date.today and end_at >= Date.today
  end
end
