module ApplicationHelper

  def mixed_case(name)
    name.downcase.gsub(/\b\w/) {|first| first.upcase }
  end
  
  #transform true/false to yes/no strings
  def boolean_to_human(test)
    test  ? "Yes" : "No"
  end
  
  def form_dates_to_json(year, month, day)
    # return if new_attributes.nil?
    # attributes = new_attributes.dup
    # args.each do |k, v| k.include?("(") ?  

    Time.local(year.to_i, month.to_i, day.to_i)
  end

  # remove couchdb and openmedia internal prooperties
  def filter_internal_properties(properties)
    properties.reject! { |k,v| ["_id", "_rev", "import_id", "couchrest-type", "created_at", "updated_at"].include?(k.to_s) }
  end
  
  def format_date(date_val)
    if date_val.is_a?(Date) || date_val.is_a?(Time)
      date_val.to_s(:full_date_only)
    else
      ""
    end
  end

  def show_fields(object, field_list)
    res = field_list.inject("<table class='property-table'>") do |html, a_field|
      if a_field.is_a?(String)
        html+="<tr>" + show_field(object, a_field) + "</tr>"
      else
        html+="<tr>" + show_field(object, * a_field) + "</tr>" 
      end
    end
    res += "</table>"
    res.html_safe
  end

  def show_field (object, field_name, field_label=field_name.to_s.humanize)
    value = nil
    if object.respond_to?(:fetch)
      value = object.fetch(field_name.to_s,'')
    else
      value = object.attributes.fetch(field_name.to_sym,'')
    end

    # if value still empty, try an accessor method with field_name
    if value.blank?
      begin
        value = object.send(field_name.to_sym)
      rescue; end
    end

    if value.is_a?(Integer)
      "<th class='property-table'>#{field_label}:</th> <td>#{number_with_delimiter(value)}</td>"
    elsif value.is_a?(Bignum)
      "<th class='property-table'>#{field_label}:</th> <td>#{number_with_delimiter(value)}</td>"
    elsif value.is_a?(Date)
      "<th class='property-table'>#{field_label}:</th> <td>#{value.to_s(:full_date_only)}</td>"
    elsif value.is_a?(Time)
      "<th class='property-table'>#{field_label}:</th> <td>#{value.to_s(:full_date_only)}</td>"
    else
      "<th class='property-table'>#{field_label}:</th> <td>#{h(value)}</td>"
    end
  end  

end
