require 'output_wrapper'

class Public::ClassesController < ApplicationController
  layout 'public'
  
  def show
    @class = OpenMedia::Schema::RDFS::Class.for(params[:id])
    @datasource = OpenMedia::Datasource.find_by_rdfs_class_uri(:key=>@class.uri.to_s)    
    @metadata = @datasource.metadata if @datasource
    @class.spira_resource.default_source(@class.skos_concept.collection.repository)
    respond_to do |format|
      format.html
      format.csv do
        headers["Content-Type"] ||= 'text/xml'
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
        records = OpenMedia::Schema.get_records(@class.uri)
        self.response_body = lambda {|response, output|
          csv = FasterCSV.new(OutputWrapper.new(output), :row_sep => "\r\n")
          csv << property_names
          records.each do |r|
            csv << property_names.collect{|pn| r[pn]}
          end

        }

      end

      format.json do
        headers["Content-Type"] ||= 'application/json'
        headers["Content-Disposition"] = "attachment; filename=\"#{@class.identifier.pluralize}.json\""
        render :json => OpenMedia::Schema.get_records(@class.uri)
      end

      format.nt do
        headers["Content-Disposition"] = "attachment; filename=\"#{@class.identifier.pluralize}.nt\""
        self.response_body = lambda {|response, output|
          RDF::Writer.for(:ntriples).new(OutputWrapper.new(output)) do |writer|
            @class.spira_resource.each do |r|
              r.statements.each {|stmt| writer << stmt}
            end
          end
        }       
      end

      format.rdf do
        headers["Content-Disposition"] = "attachment; filename=\"#{@class.identifier.pluralize}.xml\""
        self.response_body = lambda {|response, output|
          RDF::Writer.for(:rdfxml).new(OutputWrapper.new(output)) do |writer|
            @class.spira_resource.each do |r|
              r.statements.each {|stmt| writer << stmt}
            end
          end
        }       
      end      
    end
  end
end
