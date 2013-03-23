class Training < ActiveRecord::Base
  belongs_to :user
  has_many :races, :dependent => :destroy
  has_one :note, :as => :noteable, :dependent => :destroy
  
  accepts_nested_attributes_for :note, :allow_destroy => true, :reject_if => lambda { |a| a[:content].blank? }
  accepts_nested_attributes_for :races, :allow_destroy => true
  
  validates_presence_of :date, :races
  
  scope :period, lambda { |from, to| includes("races").where("date >= ? AND date <= ?", (from || 1.week.ago), (to || Date.today)).order("date DESC")}
  scope :recent, includes("races").order("date DESC").limit(5)
  
  def title
    "#{user.login}s training #{date.strftime("%e %b - %Y")}"
  end
end
