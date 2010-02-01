class Training < ActiveRecord::Base
  belongs_to :user
  has_many :races, :dependent => :destroy
  
  named_scope :recent, lambda { |*args| {:conditions => ["date > ?", (args.first || 1.week.ago)]} }
  
  validates_presence_of :title, :date
end
