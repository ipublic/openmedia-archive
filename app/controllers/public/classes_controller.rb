require 'output_wrapper'

class Public::ClassesController < ApplicationController
  layout 'public'
  
  def show
    @class = OpenMedia::Schema::RDFS::Class.for(params[:id])
    @datasource = OpenMedia::Datasource.find_by_rdfs_class_uri(:key=>@class.uri.to_s)    
    @metadata = @datasource.metadata if @datasource
    @class.spira_resource.default_source(@class.skos_concept.collection.repository)
    
    
    @dfn = OpenMedia::Schema.get_class_definition(@class.uri.to_s)
    @chart_prop = 'shift'
    @chart_prop = 'ward'
    @chart_prop = 'offense'
    @chart_title = "#{@dfn['label']} by #{@chart_prop.capitalize}"
    @chart = gen_pie_chart(@chart_title, @class.uri.to_s, @chart_prop) if @dfn['uri'] == "http://data.civicopenmedia.org/ipubliccivicopenmedialocal/classes/crime_reports"

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
  
  def gen_pie_chart(title, class_uri, property_name)
    @recs = OpenMedia::Schema.get_records(class_uri)
    @inst_counts = count_by_instance(property_name, @recs)

    @chart = GoogleVisualr::PieChart.new

    # Add Column Headers 
    @chart.add_column('string', property_name.capitalize ) # Header
    @chart.add_column('number', 'Count' ) # Header

    # Add Rows and Values 
    @chart.add_rows(@inst_counts.size)

    @row_idx, @col_idx = 0, 0
    @num_cols = 2
    @inst_counts.keys.sort.each do |k|
      @chart.set_value(@row_idx, @col_idx, k.to_s)
      @chart.set_value(@row_idx, @col_idx + 1, @inst_counts[k].to_i)
      @row_idx += 1
    end

    options = { :width => 400, :height => 240, :title => title, :is3D => false }
    options.each_pair do | k, v |
      @chart.send "#{k}=", v
    end

    @chart
  end
    
  def count_by_instance(property_name, record_array)
    instance_count = Hash.new('instance_count')
    record_array.each do |rec|
      instance_val = rec[property_name]
      instance_count.include?(instance_val) ? 
        instance_count[instance_val] += 1 : instance_count[instance_val] = 1
    end
    instance_count
  end
  
end
