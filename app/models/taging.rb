class Taging < ActiveRecord::Base
  set_table_name "taggings"
  belongs_to :track
  belongs_to :tag
end
