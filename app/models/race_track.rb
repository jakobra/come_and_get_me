class RaceTrack < ActiveRecord::Base
  has_many :race_track_segments, :dependent => :destroy
  has_many :races
  has_many :tracks, :through => :race_track_segments
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :tagings, :dependent => :destroy
  has_many :tags, :through => :tagings
  
  belongs_to :created_by_user, :class_name => "User"
  belongs_to :last_updated_by_user, :class_name => "User"
  
  belongs_to :municipality
  
  accepts_nested_attributes_for :race_track_segments, :reject_if => lambda { |a| a[:quantity].blank? }, :allow_destroy => true
  
  validates_presence_of :title, :municipality_id
  
  attr_writer :tag_names
  
  after_save :assign_tags
  
  named_scope :latest, {:limit => 5, :order => "id DESC"}
  
  def tag_names
    @tag_names || tags.map(&:name).join(", ")
  end
  
  private
  
  def assign_tags
    if @tag_names
      self.tags = @tag_names.split(/,/).map do |name|
        Tag.find_or_create_by_name(name.strip)
      end
    end
  end
  
end
