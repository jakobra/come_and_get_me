class Training < ActiveRecord::Base
  belongs_to :user
  has_many :races, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_one :note, :as => :noteable, :dependent => :destroy
  
  accepts_nested_attributes_for :note, :allow_destroy => true, :reject_if => lambda { |a| a[:content].blank? }
  accepts_nested_attributes_for :races, :allow_destroy => true
  
  validates_presence_of :date, :races
  
  named_scope :period, lambda { |*args| {:conditions => ["date >= ? AND date <= ?", (args.first || 1.week.ago), (args.last || Date.today)], :order => "date DESC", :include => :races} }
  named_scope :recent, lambda { |*args| {:limit => 5, :order => "date DESC", :include => :races} }
  
  def title
    "#{user.login}s training #{date.strftime("%e %b - %Y")}"
  end
end
