#OpenMedia::Schema::RDF::Property   # this is here to make Rails autoloading and Spira play nice together

module OpenMedia
  module Schema
    module RDFS      
      class Class < OpenMedia::Schema::Base

        default_source 'types'
        type ::RDF::RDFS.Class

        property :label, :predicate=>::RDF::RDFS.label, :type=>XSD.string
        property :comment, :predicate=>::RDF::RDFS.comment, :type=>XSD.string


        def properties
          self.uri ? self.class.repository.query(:predicate=>::RDF::RDFS.domain,
                                                 :object=>self.uri).collect {|stmt| OpenMedia::Schema::RDF::Property.for(stmt.subject)} : []
        end

        def skos_concept
          @skos_concept ||= OpenMedia::Schema::SKOS::Concept.for(self.uri)
        end

        def spira_class_name
          self.uri.to_s.split(/\W/).collect{|w| w.capitalize}.join
        end

        # define a new Spira resource, subclassed from OpenMedia::Schema::Base
        def spira_resource
          cls_name = spira_class_name
          if !self.class.const_defined?(cls_name)
            cls = ::Class.new(OpenMedia::Schema::Base)
            cls.type(self.uri)
            self.properties.each do |p|
              next if p.range==self.uri        
              ptype = nil
              if p.range
                if Spira.types[p.range]
                  ptype = p.range
                else
                  pclass = class_for_uri(p.range)
                  if pclass.is_a?(OpenMedia::Schema::RDFS::Datatype)
                    ptype = pclass.uri
                  elsif pclass.is_a?(::Class) && pclass.name =~ /OpenMedia::Schema/
                    ptype = pclass.name.to_sym
                  else
                    ptype = pclass.spira_resource.name.to_sym
                  end            
                end
              end
              pname = p.identifier == 'type' ? p.label.downcase.gsub(/[^a-z0-9]/,'_').gsub(/^\-|\-$/,'').squeeze('_') : p.identifier.to_sym
              cls.property(pname, :predicate=>p.uri, :type=>ptype)                  
            end
            self.class.const_set(cls_name, cls)
          end
          self.class.const_get(cls_name)
        end

        # this method finds either an OpenMedia::Schema::RDFS::Class or an OpenMedia::Schema::OWL::Class
        # for the given uri, or raises a TypeError
        def class_for_uri(uri)
          case uri
          when ::RDF::RDFS.Class then OpenMedia::Schema::RDFS::Class
          when ::RDF::RDFS.Datatype then OpenMedia::Schema::RDFS::Datatype
          when ::RDF::OWL.Class then OpenMedia::Schema::OWL::Class
          else
            statements = self.class.repository.query(:subject=>uri, :predicate=>::RDF.type)
            type_statement = statements.detect {|s| s.object==::RDF::RDFS.Class || s.object==::RDF::OWL.Class || s.object==::RDF::RDFS.Datatype}
            if type_statement
              type_type = case type_statement.object
                          when ::RDF::RDFS.Class then OpenMedia::Schema::RDFS::Class
                          when ::RDF::OWL.Class then OpenMedia::Schema::OWL::Class
                          when ::RDF::RDFS.Datatype then OpenMedia::Schema::RDFS::Datatype
                          end
              type_type.for(uri)        
            else
              raise TypeError, "Cannot find RDFS or OWL class in types repository for #{uri}"
            end
          end
        end

        def instance_count
          repo = Spira.repository(self.skos_concept.collection.repository)
          repo.query(:predicate=>::RDF.type, :object=>self.uri).count    
        end


        def self.create_in_site!(site, data)
          identifier = data[:label].downcase.gsub(/[^a-z0-9]/,'_').gsub(/^\-|\-$/,'').squeeze('_')
          c = self.for("#{site.identifier}/classes/#{identifier}", data)
          raise Exception.new("Class #{identifier} already exists") if c.exists?    
          c.save!
          self.repository_or_fail.insert(::RDF::Statement.new(c.subject, ::RDF.type, ::RDF::SKOS.Concept))
          c    
        end

        def self.prefix_search(startkey)
          DesignDoc.get.view('class_uri_by_name', :startkey=>startkey, :endkey=>"#{startkey}\uffff")['rows'].collect {|r| ::RDF::URI.new(r['value'][1..-2])}.uniq
        end

        # convenience methods for working with spira resource
        def new(data={})
          self.spira_resource.new(data)
        end

        def for(uri, data={})
          self.spira_resource.for(uri, data)
        end

        def after_destroy
          self.skos_concept.destroy! if self.skos_concept
          self.spira_resource.each {|r| r.destroy!}
        end

      end
    end
  end
end
    
