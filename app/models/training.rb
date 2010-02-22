class Training < ActiveRecord::Base
  belongs_to :user
  has_many :races, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
  
  named_scope :period, lambda { |*args| {:conditions => ["date >= ? AND date <= ?", (args.first || 1.week.ago), (args.last || Date.today)], :order => "date DESC", :include => :races} }
  #named_scope :recent, lambda { |*args| {:conditions => ["date > ?", (args.first || 1.week.ago)], :order => "date DESC"} }
  named_scope :recent, lambda { |*args| {:limit => 5, :order => "date DESC", :include => :races} }
  
  validates_presence_of :date
  
  def title
    "#{user.login}s training #{date.strftime("%e %b - %Y")}"
  end
end
