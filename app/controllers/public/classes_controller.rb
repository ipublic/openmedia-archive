require 'output_wrapper'

class Public::ClassesController < ApplicationController
  layout 'public'
  
  def show
    @class = OpenMedia::Schema::RDFS::Class.for(params[:id])
    @metadata = OpenMedia::Datasource.find_by_rdfs_class_uri(:key=>@class.uri.to_s).metadata
    @class.spira_resource.default_source(@class.skos_concept.collection.repository)
    respond_to do |format|
      format.html
      format.xml do
        headers["Content-Type"] ||= 'text/xml'
        headers["Content-Disposition"] = "attachment; filename=\"#{@class.identifier.pluralize}.xml\""          
        self.response_body = lambda {|response, output|
          output.write('<?xml version="1.0" encoding="UTF-8"?>' + "\n")
          output.write("<#{@class.identifier.pluralize}_dataset uri=\"#{@class.uri.to_s}\">")
          @class.spira_resource.each do |r|
            output.write(r.attributes.reject{|k,v| k==:metadata}.to_xml(:skip_instruct=>true, :root=>@class.identifier))
          end
          output.write("</#{@class.identifier.pluralize}>_dataaset")          

        }
      end
      format.csv do
        headers["Content-Type"] ||= 'text/xml'
        headers["Content-Disposition"] = "attachment; filename=\"#{@class.identifier.pluralize}.xml\""
        #this is required if you want this to work with IE		
        if request.env['HTTP_USER_AGENT'] =~ /msie/i
          headers['Pragma'] = 'public'
          headers["Content-type"] = "text/plain"
          headers['Cache-Control'] = 'no-cache, must-revalidate, post-check=0, pre-check=0'
          headers['Content-Disposition'] = "attachment; filename=\"#{@class.identifier.pluralize}.csv\""
          headers['Expires'] = "0"
        else
          headers["Content-Type"] ||= 'text/csv'
          headers["Content-Disposition"] = "attachment; filename=\"#{@class.identifier.pluralize}.csv\"" 
        end
        property_names = @class.properties.collect{|p| p.identifier}.sort
        self.response_body = lambda {|response, output|
          csv = FasterCSV.new(OutputWrapper.new(output), :row_sep => "\r\n")
          csv << property_names
          @class.spira_resource.each do |r|
            csv << property_names.collect{|pn| r.attributes[pn.to_sym]}
          end          
        }

      end

      format.json do
        headers["Content-Type"] ||= 'application/json'
        headers["Content-Disposition"] = "attachment; filename=\"#{@class.identifier.pluralize}.json\""          
        self.response_body = lambda {|response, output|
          output.write('[')
          first = true
          @class.spira_resource.each do |r|
            output.write(',') unless first
            first = false
            output.write(r.attributes.reject{|k,v| k==:metadata}.to_json)
          end
          output.write(']')
        }        
      end
    end


  end

end
