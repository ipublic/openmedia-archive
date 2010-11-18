module MetadataHelper
  
  def format_metadata_date(raw_date)
    return "undefined" if raw_date.blank?
    rtn = !raw_date.nil? ? raw_date.to_time.to_s(:full_date_only) : "undefined"
  end
  
end
