#OpenMedia::Schema::RDF::Property   # this is here to make Rails autoloading and Spira play nice together

module OpenMedia
  module Schema
    module RDFS      
      class Class < OpenMedia::Schema::Base

        default_source 'types'
        type ::RDF::RDFS.Class

        property :label, :predicate=>::RDF::RDFS.label, :type=>XSD.string
        property :comment, :predicate=>::RDF::RDFS.comment, :type=>XSD.string

        RDFS_CLASS_DESIGN_DOC_ID = "_design/rdfs_class"

        SCHEMA_PREDICATES = [::RDF.type, ::RDF::RDFS.label, ::RDF::RDFS.comment, ::RDF::RDFS.range, ::RDF::RDFS.domain]
        SCHEMA_PREDICATE_CONDITIONAL = SCHEMA_PREDICATES.collect{|p| "doc['predicate']=='<#{p}>'"}.join(" || ")

        RDFS_CLASS_DESIGN_DOC = {
          "_id" => RDFS_CLASS_DESIGN_DOC_ID,
          "language" => "javascript",
          "views" => {
            'by_name' => {
              'map' => "function(doc) {
                      if (doc['subject'] && doc['predicate'] && doc['object'] &&
                          doc['predicate'] == '<#{::RDF.type}>' && (doc['object'] == '<#{::RDF::RDFS.Class}>' || doc['object'] == '<#{::RDF::RDFS.Datatype}>' || doc['object'] == '<#{OWL.Class}>')) {
                          var typeName = doc['subject'].substring(1, doc['subject'].length - 1);
                          if (typeName.indexOf('#') != -1) {
                            typeName = typeName.split('#')[1];
                          } else {
                            var parts = typeName.split('/');
                            typeName = parts[parts.length-1];
                          }
                          emit(typeName, doc['subject']);
                      }
                  }"
            },
            'schema_by_uri' => {
              'map' => "function(doc) {     
                            if(doc['subject'] && doc['predicate'] && doc['object']) {
                                if (#{SCHEMA_PREDICATE_CONDITIONAL}) {
                                    emit(doc['subject'].substring(1,doc['subject'].length-1), doc);
                                }
                            }

                        }"
            }
          },
          "lists" => {
            'class_definition' => "function(head, req) {
                                       classDef = {uri: null, properties: []};
                                       rows = {};
                                       while (row = getRow()) {
                                            if (!rows[row.key]) {
                                                rows[row.key] = [];
                                            }
                                            rows[row.key].push(row.value);

                                            if (row.value.predicate=='<#{::RDF.type}>') {
                                                if (row.value.object == '<#{::RDF::RDFS.Class}>' || row.value.object == '<#{::RDF::RDFS.Datatype}>' || row.value.object == '<#{OWL.Class}>') {
                                                    classDef.uri = row.value.subject;
                                                } else if (row.value.object=='<#{::RDF.Property}>') {
                                                    if (!classDef.properties) {
                                                        classDef.properties = [];
                                                    }
                                                    classDef.properties.push({uri: row.value.subject});
                                                } else if (row.value.object=='<#{::RDF::OWL.DatatypeProperty}>') {
                                                    if (!classDef.objectProperties) {
                                                        classDef.objectProperties = [];
                                                    }
                                                    classDef.objectProperties.push({uri: row.value.subject});
                                                } else if (row.value.object=='<#{::RDF::OWL.ObjectProperty}>') {
                                                    if (!classDef.datatypeProperties) {
                                                        classDef.datatypeProperties = [];
                                                    }
                                                    classDef.datatypeProperties.push({uri: row.value.subject});
                                                }
                                            }
                                       }

                                       var lookup = function(subject, predicate) {
                                           var value = null;
                                           key = subject.substring(1, subject.length -1);
                                           if (rows[key]) {
                                               for (var i=0; i<rows[key].length; i++) {
                                                   if (rows[key][i].predicate==predicate) {
                                                       value = rows[key][i].object;
                                                   }
                                               }
                                           }
                                           return value;
                                       }
                                       classDef.label = lookup(classDef.uri, '<#{::RDF::RDFS.label}>');
                                       classDef.comment = lookup(classDef.uri, '<#{::RDF::RDFS.comment}>');
                                       if (classDef.properties) {
                                           for (var i=0; i<classDef.properties.length; i++) {
                                               classDef.properties[i].label = lookup(classDef.properties[i].uri, '<#{::RDF::RDFS.label}>');
                                               classDef.properties[i].comment = lookup(classDef.properties[i].uri, '<#{::RDF::RDFS.comment}>');
                                               classDef.properties[i].range = lookup(classDef.properties[i].uri, '<#{::RDF::RDFS.range}>');
                                           }
                                       }
                                       send(toJSON(classDef));
                                   }"
          }
        }

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
          design_doc.view('by_name', :startkey=>startkey, :endkey=>"#{startkey}\uffff")['rows'].collect {|r| ::RDF::URI.new(r['value'][1..-2])}.uniq
        end

        def self.refresh_design_doc(force = false)
          @design_doc = CouchRest::Design.new(RDFS_CLASS_DESIGN_DOC)        
          stored_design_doc = nil
          begin
            stored_design_doc = TYPES_DATABASE.get(RDFS_CLASS_DESIGN_DOC_ID)
            changes = force
            @design_doc['views'].each do |name, view|
              if !compare_views(stored_design_doc['views'][name], view)
                changes = true
                stored_design_doc['views'][name] = view
              end
            end

            @design_doc['lists'].each do |name, list|
              if !compare_js(stored_design_doc['lists'][name], list)
                changes = true
                stored_design_doc['lists'][name] = list
              end
            end
            
            if changes
              TYPES_DATABASE.save_doc(stored_design_doc)
            end
            @design_doc = stored_design_doc          
          rescue => e
            puts e.backtrace.join("\n")
            puts e.inspect
            @design_doc = CouchRest::Design.new(RDFS_CLASS_DESIGN_DOC)
            @design_doc.database = TYPES_DATABASE
            @design_doc.save
          end        
        end

        def self.design_doc
          @design_doc ||= TYPES_DATABASE.get(RDFS_CLASS_DESIGN_DOC_ID)
        end

        # Return true if the two views match (borrowed this from couchrest-model)
        def self.compare_views(orig, repl)
          return false if orig.nil? or repl.nil?
          compare_js(orig['map'], repl['map']) && compare_js(orig['reduce'], repl['reduce'])
        end

        def self.compare_js(orig, repl)
          return false if orig.nil? or repl.nil?
          (orig.to_s.strip == repl.to_s.strip)
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
    
