module OpenMedia
  module Schema
    class DataDesignDoc

      DATA_DESIGN_DOC_ID = "_design/schema_data"

      DATA_DESIGN_DOC = {
        "_id" => DATA_DESIGN_DOC_ID,
        "language" => "javascript",

        "views" => {
          'properties_by_uri' => {
            'map' => "function(doc) {
                          if(doc['subject'] && doc['predicate'] && (doc['predicate'] != '<#{::RDF.type}>')) {
                              emit(doc['subject'], 1);
                          }
                      }"
          }
        },

        "lists" => {

          'records' => "function(head, req) {
                             records = [];
                             recordsByURI = {};

                             var trimBrackets = function(str) { return str.replace('<','').replace('>',''); }
                             var trimQuotes = function(str) { return str.replace(/\"/g,''); }
                             var trimLiteral = function(str) {
                                 if (str.indexOf('^^') != -1) {
                                     return str.substring(0, str.indexOf('^^'));
                                 } else {
                                     return str;
                                 }
                             }

                             while (row = getRow()) {
                                 if (row['doc'] && row['doc']['subject']) {
                                     var uri = row['doc']['subject'];
                                     var rec = recordsByURI[uri];
                                     if (!rec) {
                                         rec = {};
                                         recordsByURI[uri] = rec;
                                         records.push(rec);
                                     }
                                     var predicate = trimBrackets(row['doc']['predicate']);
                                     var propertyIdentifier = null;
                                     if (predicate.indexOf('#') != -1) {
                                         propertyIdentifier = predicate.substring(predicate.indexOf('#')+1);
                                     } else {
                                         propertyIdentifier = predicate.substring(predicate.lastIndexOf('/')+1);
                                     }
                                     rec[propertyIdentifier] = trimLiteral(trimBrackets(trimQuotes(row['doc']['object'])));
                                 }
                             }
                             send(toJSON(records));                             
                        }"

        }
      }
    

      def self.get
        @design_doc
      end

      def self.refresh(db, force = false)
        @design_doc = CouchRest::Design.new(DATA_DESIGN_DOC)        
        stored_design_doc = nil
        begin
          stored_design_doc = db.get(DATA_DESIGN_DOC_ID)
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
            db.save_doc(stored_design_doc)
          end
          @design_doc = stored_design_doc          
        rescue => e
          @design_doc = CouchRest::Design.new(DATA_DESIGN_DOC)
          @design_doc.database = db
          @design_doc.save
        end        
      end

      def self.design_doc(db)
        @design_doc ||= db.get(DATA_DESIGN_DOC_ID)
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
