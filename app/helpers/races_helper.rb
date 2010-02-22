module RacesHelper
  
  def form_input_field?(input_field)
    params[:field].blank? || params[:field] == input_field
  end
end
