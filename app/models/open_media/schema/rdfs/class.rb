OpenMedia::Schema::RDF::Property   # this is here to make Rails autoloading and Spira play nice together

class OpenMedia::Schema::RDFS::Class < OpenMedia::Schema::Base
  
  default_source 'types'
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
                          doc['predicate'] == '<#{RDF.type}>' && (doc['object'] == '<#{RDFS.Class}>' || doc['object'] == '<#{RDFS.Datatype}>' || doc['object'] == '<#{OWL.Class}>')) {
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
        if Spira.types[p.range]
          ptype = p.range
        else
          ptype = class_for_uri(p.range).spira_resource.name.to_sym
        end
        cls.property(p.identifier.to_sym, :predicate=>p.uri, :type=>ptype)                  
      end
      self.class.const_set(cls_name, cls)
    end
    self.class.const_get(cls_name)
  end

  # this method finds either an OpenMedia::Schema::RDFS::Class or an OpenMedia::Schema::OWL::Class
  # for the given uri, or raises a TypeError
  def class_for_uri(uri)
    statements = self.class.repository.query(:subject=>uri, :predicate=>RDF.type)
    type_statement = statements.detect {|s| s.object==RDFS.Class || s.object==OWL.Class}
    if type_statement
      type_type = type_statement.subject==RDFS.Class ? OpenMedia::Schema::RDFS::Class : OpenMedia::Schema::OWL::Class
      type_type.for(uri)
    else
      raise TypeError, "Cannot find RDFS or OWL class in types repository for #{uri}"
    end
  end


  def instance_count
    repo = Spira.repository(self.skos_concept.collection.repository)
    repo.query(:predicate=>RDF.type, :object=>self.uri).count    
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



