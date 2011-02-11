OpenMedia::Schema::RDF::Property   # this is here to make Rails autoloading and Spira play nice together

class OpenMedia::Schema::RDFS::Class < OpenMedia::Schema::Base
  
  default_source :types
  base_uri "http://data.civicopenmedia.org/"
  type RDFS.Class

  property :label, :predicate=>RDFS.label, :type=>XSD.string
  property :comment, :predicate=>RDFS.comment, :type=>XSD.string
  has_many :properties, :predicate=>RDF.Property, :type=>:'OpenMedia::Schema::RDF::Property'

  RDFS_CLASS_DESIGN_DOC_ID = "_design/rdfs_class"

  RDFS_CLASS_DESIGN_DOC = {
    "_id" => RDFS_CLASS_DESIGN_DOC_ID,
    "language" => "javascript",
    "views" => {
      'by_name' => {
        'map' => "function(doc) {
                      if (doc['subject'] && doc['predicate'] && doc['object'] &&
                          doc['predicate'] == '<#{RDF.type}>' && (doc['object'] == '<#{RDFS.Class}>' || doc['object'] == '<#{RDFS.Datatype}>')) {
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
      }
    }
  }

  def skos_concept
    @skos_concept ||= OpenMedia::Schema::SKOS::Concept.for(self.uri)
  end


  # define a new Spira resource, subclassed from OpenMedia::Schema::Base
  def spira_resource
    cls_name = self.uri.path.split('/').collect{|p| p.classify}.join
    if !self.class.const_defined?(cls_name)
      cls = Class.new(OpenMedia::Schema::Base)
      repo = self.skos_concept.collection.repository
      cls.default_source(repo)
      cls.type(self.uri)
      self.properties.each do |p|
        cls.property(p.identifier.to_sym, :predicate=>p.uri, :type=>p.range)
      end
      self.class.const_set(cls_name, cls)
    end
    self.class.const_get(cls_name)
  end

  def self.create_in_site!(site, data)
    identifier = data[:label].downcase.gsub(/[^a-z0-9]/,'_').gsub(/^\-|\-$/,'').squeeze('_')
    c = self.for("#{site.identifier}/classes/#{identifier}", data)
    raise Exception.new("Class #{identifier} already exists") if c.exists?    
    c.save!
    self.repository_or_fail.insert(RDF::Statement.new(c.subject, RDF.type, RDF::SKOS.Concept))
    c    
  end

  def self.prefix_search(startkey)
    design_doc.view('by_name', :startkey=>startkey, :endkey=>"#{startkey}\uffff")['rows'].collect {|r| RDF::URI.new(r['value'][1..-2])}.uniq
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
      if changes
        TYPES_DATABASE.save_doc(stored_design_doc)
      end
      @design_doc = stored_design_doc          
    rescue => e
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
    (orig['map'].to_s.strip == repl['map'].to_s.strip) && (orig['reduce'].to_s.strip == repl['reduce'].to_s.strip)
  end
  


end



