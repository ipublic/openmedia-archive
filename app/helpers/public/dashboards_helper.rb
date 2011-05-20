module Public::DashboardsHelper


  def show_measure(m)
    rec = ''
    if ['bullet', 'pie'].include? m['visual']
      if ['pie'].include? m['visual']
        rec += "<td>&nbsp;</td> <td>" + format_field(m.values[m.values.size - 2], m['format']) + "</td>"
      else
        rec += "<td>&nbsp;</td> <td>&nbsp;</td>"
      end
    else
      rec += "<td>" + format_field(m.values[m.values.size - 2], m['format']) + "</td>"
      rec += "<td>" + format_field(m.values.last, m['format']) + "</td>"
    end
    m["rank"].blank? ? rec += "<td>&nbsp;</td>" : rec += "<td>" + m["rank"].to_i.ordinalize + "</td>" 
    if m['visual']
      rec += "<td class='#{m['visual']}'>" + m.values.join(',') + "</td>"
    else
      rec += "<td>&nbsp;</td>"
    end
    rec.html_safe
  end


  def format_field(value, format)
    if !format.nil?
      value = case format
      when "number": number_with_delimiter(value)
      when "percentage": number_to_percentage(value, :precision => 2)
      when "currency": number_to_currency(value, :precision => 0, :negative_format => "(%u%n)")
      else value
    end
    else
      return value
    end
  end
  
end
