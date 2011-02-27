module OpenMedia
  module Schema
    module OWL
      class Class < OpenMedia::Schema::RDFS::Class
        type ::RDF::OWL.Class

        def self.create_in_site!(site, data)
          identifier = data[:label].downcase.gsub(/[^a-z0-9]/,'_').gsub(/^\-|\-$/,'').squeeze('_')
          c = self.for("#{site.identifier}/classes/#{identifier}", data)
          raise Exception.new("Class #{identifier} already exists") if c.exists?    
          c.save!
          c    
        end

        def datatype_properties
          unless @datatype_properties
            if self.uri
              query = ::RDF::Query.new(:property=>{::RDF.type => ::RDF::OWL.DatatypeProperty, ::RDF::RDFS.domain => self.uri})
              @datatype_properties = query.execute(self.class.repository).collect do |solution|
                OpenMedia::Schema::OWL::DatatypeProperty.for(solution[:property])
              end
            else
              @datatype_properties = []
            end
          end
          @datatype_properties
        end

        def object_properties
          unless @object_properties
            if self.uri
              query = ::RDF::Query.new(:property=>{::RDF.type => ::RDF::OWL.ObjectProperty, ::RDF::RDFS.domain => self.uri})
              @object_properties = query.execute(self.class.repository).collect do |solution|
                OpenMedia::Schema::OWL::ObjectProperty.for(solution[:property])
              end
            else
              @object_properties = []
            end
          end
          @object_properties
        end  
        
        # define a new Spira resource, subclassed from OpenMedia::Schema::Base
        def spira_resource
          cls_name = spira_class_name
          if !self.class.const_defined?(cls_name)
            cls = ::Class.new(OpenMedia::Schema::Base)
            cls.default_source(self.class.repository_name)
            cls.type(self.uri)
            [self.properties, self.object_properties, self.datatype_properties].each do |prop_list|
              prop_list.each do |p|
                ptype = nil
                next if p.range==self.uri
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
                # Every property is an array at the moment....
                cls.has_many(p.identifier.to_sym, :predicate=>p.uri, :type=>ptype)
              end
            end
            self.class.const_set(cls_name, cls)
          end
          self.class.const_get(cls_name)
        end
      end
    end
  end
end


