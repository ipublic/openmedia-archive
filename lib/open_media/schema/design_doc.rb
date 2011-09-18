module OpenMedia
  module Schema
    class DesignDoc

      SCHEMA_DESIGN_DOC_ID = "_design/schema"

      SCHEMA_PREDICATES = [::RDF.type, ::RDF::RDFS.label, ::RDF::RDFS.comment, ::RDF::RDFS.range, ::RDF::RDFS.domain,
                           ::RDF::SKOS.prefLabel, ::RDF::SKOS.member, ::RDF::SKOS.Collection, ::RDF::SKOS.Concept,
                           ::RDF::DC.modified, ::RDF::DC.created]
      SCHEMA_PREDICATE_CONDITIONAL = SCHEMA_PREDICATES.collect{|p| "doc['predicate']=='<#{p}>'"}.join(" || ")

      SCHEMA_DESIGN_DOC = {
        "_id" => SCHEMA_DESIGN_DOC_ID,
        "language" => "javascript",
        "views" => {
          'class_uri_by_name' => {
            'map' => "function(doc) {
                      if (doc['subject'] && doc['predicate'] && doc['object'] &&
                          doc['predicate'] == '<#{::RDF.type}>' && (doc['object'] == '<#{::RDF::RDFS.Class}>' || doc['object'] == '<#{::RDF::RDFS.Datatype}>' || doc['object'] == '<#{::RDF::OWL.Class}>')) {
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
                                    if (doc['subject'].indexOf('#') != -1) {
                                        emit(doc['subject'].substring(1,doc['subject'].indexOf('#')), doc);
                                    } else {
                                        emit(doc['subject'].substring(1,doc['subject'].length-1), doc);
                                    }
                                }
                            }

                        }"
          },
          'classes_with_geometry' => {
            'map' => "function(doc) {
                          if(doc['subject'] && doc['predicate'] && doc['object'] && (doc['predicate'] == '<#{::RDF::RDFS.domain}>') && (doc['subject'].match(/#geometry>$/))) {
                              emit(doc['object'].substring(1,doc['object'].length-1), 1);
                          }
                      }"
          }

        },

        "lists" => {
          'class_definition' => "function(head, req) {
                                       classDef = {uri: null, properties: []};
                                       rows = {};
                                       while (row = getRow()) {
                                            if (!rows[row.value.subject]) {
                                                rows[row.value.subject] = [];
                                            }
                                            rows[row.value.subject].push(row.value);

                                            if (row.value.predicate=='<#{::RDF.type}>') {
                                                if (row.value.object == '<#{::RDF::RDFS.Class}>' || row.value.object == '<#{::RDF::RDFS.Datatype}>' || row.value.object == '<#{::RDF::OWL.Class}>') {
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
                                       var trimBrackets = function(str) { return str.replace('<','').replace('>',''); }
                                       var trimQuotes = function(str) { return str.replace(/\"/g,''); }
                                       var trimLiteral = function(str) {
                                           if (str.indexOf('^^') != -1) {
                                               return str.substring(0, str.indexOf('^^'));
                                           } else {
                                               return str;
                                           }
                                       }

                                       var lookup = function(subject, predicate){ 
                                           var value = null;
                                           if (rows[subject]) {
                                               for (var i=0; i<rows[subject].length; i++) {
                                                   if (rows[subject][i].predicate==predicate) {
                                                       value = rows[subject][i].object;
                                                   }
                                               }
                                           }
                                           if (value!=null) { value = trimLiteral(trimBrackets(trimQuotes(value))); }
                                           return value;
                                       }

                                       classDef.label = lookup(classDef.uri, '<#{::RDF::RDFS.label}>');
                                       classDef.comment = lookup(classDef.uri, '<#{::RDF::RDFS.comment}>');
                                       classDef.created = lookup(classDef.uri, '<#{::RDF::DC.created}>');
                                       classDef.modified = lookup(classDef.uri, '<#{::RDF::DC.modified}>');
                                       if (classDef.properties) {
                                           for (var i=0; i<classDef.properties.length; i++) {
                                               classDef.properties[i].label = lookup(classDef.properties[i].uri, '<#{::RDF::RDFS.label}>');
                                               classDef.properties[i].comment = lookup(classDef.properties[i].uri, '<#{::RDF::RDFS.comment}>');
                                               classDef.properties[i].range = lookup(classDef.properties[i].uri, '<#{::RDF::RDFS.range}>');
                                               classDef.properties[i].uri = trimBrackets(classDef.properties[i].uri);
                                               classDef.properties[i].identifier = classDef.properties[i].uri.substring(classDef.properties[i].uri.indexOf('#')+1);
                                           }
                                       }
                                       if (classDef.uri) {
                                           classDef.uri = trimBrackets(classDef.uri);                                       
                                           send(toJSON(classDef));
                                       } else {
                                           throw (['error', 'not_found', 'Class not found'])
                                       }
                                   }"
        }
      }
    

      def self.get
        @design_doc
      end

      def self.refresh(force = false)
        @design_doc = CouchRest::Design.new(SCHEMA_DESIGN_DOC)        
        stored_design_doc = nil
        begin
          stored_design_doc = VOCABULARIES_DATABASE.get(SCHEMA_DESIGN_DOC_ID)
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
            VOCABULARIES_DATABASE.save_doc(stored_design_doc)
          end
          @design_doc = stored_design_doc          
        rescue => e
          @design_doc = CouchRest::Design.new(SCHEMA_DESIGN_DOC)
          @design_doc.database = VOCABULARIES_DATABASE
          @design_doc.save
        end        
      end

      def self.design_doc
        @design_doc ||= VOCABULARIES_DATABASE.get(SCHEMA_DESIGN_DOC_ID)
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
      

    end
  end
end
