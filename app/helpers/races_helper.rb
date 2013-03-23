module RacesHelper
  def form_input_field?(input_field)
    params[:field].blank? || params[:field] == input_field
  end
  
  def percentage_of_hr_max(hr, hr_max)
    @hr_max_disclaimer = true
    (hr/hr_max * 100).round
  end
end
