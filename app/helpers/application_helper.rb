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

end
