module Public::DashboardsHelper

  def format_field(value, format)
    if !format.nil?
      value = case format
      when "percentage": number_to_percentage(value, :precision => 1)
      when "currency": number_to_currency(value, :precision => 0, :negative_format => "(%u%n)")
      else value
    end
    else
      return value
    end
  end
  
end
