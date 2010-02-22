module TrainingsHelper
  
  def add_race_field_link(name)
    link_to_function name do |page|
  		page.insert_html :bottom, :races, :partial => "race_fields", :object => Race.new
  	end
  end
  
end
